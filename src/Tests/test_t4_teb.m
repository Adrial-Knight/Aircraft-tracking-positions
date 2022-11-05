clear;
close all;
clc;
addpath('../PHY');

%% Variables à modifier
min_erreur = 10000;       % nombre minimal d'erreur avant d'obtenir un point 
threshold = [0.4*ones(1, 3) 0.45*ones(1, 3) 0.6*ones(1, 3) 0.75*ones(1, 4)]; % entre 0 et 1, on en démodule pas en dessous de cette valeur
influence_module  = 1;

%% Initialisation des paramètres
Nb = 1000;              % Nombre de bits par paquet
Fse = 20;            % facteur de sur-échantillonnage
Fe = 20e6; % Frequence d'echantillonnage (imposee par le serveur)

%% Simulation

eb_n0_dB = 0:1:10;                               % Liste des Eb / N0 en dB
eb_n0 = 10.^(eb_n0_dB /10) ;          % Liste des Eb / N0
p = 0.5 * [ones(1, Fse/2), -1*ones(1, Fse/2)];
Eg = sum(abs(p) .^2);                           %energie du filtre
sigma2 = Eg./ (2*eb_n0) ;                      % Variance du bruit

TEB_estime = zeros(size(eb_n0)) ;                     % Tableau des TEB ( résultats )
if(influence_module)
    TEB_module = zeros(size(eb_n0)) ;
end
Pb = qfunc (sqrt(2*eb_n0));                   % Tableau des probabilités d ’erreurs théoriques
left_ = 0;
leftp = 0;
all = 0;
sp = get_preamble(Fse);
sp_mod = sqrt(sum(sp.^2));
for i = 1: length (eb_n0)
    clc;
    fprintf("Il reste " + int2str(length (eb_n0) - i + 1) + " TEB à évaluer.");
    error_cnt_estime = 0;
    error_cnt_module = 0;
    bit_cnt = 0;
    while error_cnt_estime < min_erreur
        delta_t = randi(100);
        delta_f = rand(1)*2e3 - 1e3;
        b = randi([0, 1], 1, Nb);
        
        % Emetteur
        s_l = [sp modulatePPM(b, Fse)];
        
        % Canal
        n_l = sqrt(sigma2(i)) * randn(1, length(s_l) + delta_t);

        t = (0:1:length(n_l)-1)/Fe; 
        y_l = [zeros(1, floor(delta_t)) s_l] .* exp(-1j*2*pi*delta_f*t) + n_l ;
        
        % Récepteur
        rl = abs(y_l).^2;
        [delta_t_estime, rho_t] = sync_tmp_p(rl, sp, threshold(i));
        delta_t_estime = delta_t_estime(1);
        rl_estime = rl(delta_t_estime+length(sp)+1: length(rl));
        if (influence_module)
            rl_module = rl(delta_t+length(sp)+1: length(rl));
        end

        % Chaine RX
        
        vl_estime = conv(rl_estime, p);
        rm_estime = downsample(vl_estime(Fse:length(vl_estime)), Fse);
        b_rec_estime = rm_estime < 0;
        
        left = length(b_rec_estime) - length(b);
        if(left > 0)
            b_rec_estime = b_rec_estime(left+1: length(b_rec_estime));
        end
        if(left < 0)
            b_rec_estime = [zeros(1, -left) b_rec_estime];
        end

        Nb_erreur_estime = sum(b ~= b_rec_estime);
        error_cnt_estime = error_cnt_estime + Nb_erreur_estime;
        
        if(influence_module)
            vl_module = conv(rl_module, p);
            rm_module = downsample(vl_module(Fse:length(vl_module)), Fse);
            b_rec_module = rm_module < 0;
            
            left = length(b_rec_module) - length(b);
            if(left > 0)
                b_rec_module = b_rec_module(left+1: length(b_rec_module));
            end
            if(left < 0)
                b_rec_module = [zeros(1, -left) b_rec_module];
            end

            Nb_erreur_module = sum(b ~= b_rec_module);
            error_cnt_module = error_cnt_module + Nb_erreur_module;
        end
        
        bit_cnt = bit_cnt + Nb;

    end
    TEB_estime(i) = error_cnt_estime / bit_cnt;
    if(influence_module)
        TEB_module(i) = error_cnt_module / bit_cnt;
    end
end
clc;

%% Affichage
semilogy(eb_n0_dB, Pb);
if (influence_module)
    hold on;
    semilogy(eb_n0_dB, TEB_module, '-s');
end
hold on;
semilogy(eb_n0_dB, TEB_estime, '-s');
hold off;
if (influence_module)
    legend('Théorie', 'impact module', 'desynchronisation');
else
    legend('Théorie', 'impact module');
end

xlabel('Rapport signal sur bruit (Eb/N0)');
ylabel('Probabilité d''erreur binaire');

title("TEB");
grid;