%% init
clear; close all; clc;

addpath('../PHY');
%% variables
Fe = 20e6; % Frequence d'echantillonnage (imposee par le serveur)
Rb = 1e6;% Debit binaire (=debit symbole)
Fse = floor(Fe/Rb); % Nombre d'echantillons par symboles
Nb = 1000; % Nombre de bit par trame
sigma=0; % variance du bruit

max_delta_t = 100;
max_delta_f = 1000;
threshold = 0.75;

%% Chaîne TX
delta_t = randi(max_delta_t);
delta_f = randi(2*max_delta_f) - max_delta_f;

b = randi([0,1], 1, Nb);
s_l = modulatePPM(b, Fse);
sp = get_preamble(Fse);

n_l = sigma  * randn(1, length(sp) + length(s_l) + floor(delta_t));

t = (0:1:length(n_l)-1)/Fe; 
y_l = [zeros(1, floor(delta_t)) sp s_l] .* exp(-1j*2*pi*delta_f*t) + n_l ;

%% Estimation de delta_t
rl = abs(y_l).^2;
[delta_t_estime, rho] = sync_tmp_p(rl, sp, threshold);

%% Affichage des résultats
fprintf(int2str(delta_t) + " est estimé à "+int2str(delta_t_estime)+" avec un rho à "+num2str(rho)+"\n");