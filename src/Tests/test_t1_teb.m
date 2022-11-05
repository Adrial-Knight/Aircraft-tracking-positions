clear;
close all;
clc;

%% Variables à modifier
min_erreur = 100;       % nombre minimal d'erreur avant d'obtenir un point 

%% Initialisation des paramètres
Nb = 1000;              % Nombre de bits par paquet
Fse = 20;            % facteur de sur-échantillonnage

eb_n0_dB = 0:1:10;                               % Liste des Eb / N0 en dB
eb_n0 = 10.^(eb_n0_dB /10) ;          % Liste des Eb / N0
sigma2 = 5./ (2*eb_n0) ;                      % Variance du bruit

TEB = zeros(size(eb_n0)) ;                     % Tableau des TEB ( résultats )
Pb = qfunc (sqrt(2*eb_n0));                   % Tableau des probabilités d ’erreurs théoriques

for i = 1: length (eb_n0)
    clc;
    fprintf("Il reste " + int2str(length (eb_n0) - i + 1) + " TEB à évaluer.");
    error_cnt = 0;
    bit_cnt = 0;
    while error_cnt < min_erreur
        b = randi([0, 1], 1, Nb);
        
        % Chaîne TX
        sl = modulatePPM_p(b,Fse);
        
        % Canal
        nl = sqrt(sigma2(i)).*(randn(size(sl))); % Génération du bruit
        yl = sl + nl;

        % Chaine RX
        p = 0.5 * [ones(1, Fse/2), -1*ones(1, Fse/2)];
        rl = conv(yl, p);
        rm = downsample(rl(Fse:length(rl)), Fse);
        b_rec = rm < 0;

        Nb_erreur = sum(b ~= b_rec);
        error_cnt = error_cnt + Nb_erreur;
        bit_cnt = bit_cnt + Nb;
    end
    TEB(i) = error_cnt / bit_cnt;
end
clc;

%% Affichage
semilogy(eb_n0_dB, Pb);
hold on;
semilogy(eb_n0_dB, TEB, 's');
hold off;

xlabel('Rapport signal sur bruit (Eb/N0)');
ylabel('Probabilité d''erreur binaire');
legend('Théorie', "Simulation");
title("TEB");
grid;