clear 
close all
clc

addpath('../PHY');

%% 
Fe = 20e6; % Frequence d'echantillonnage (imposee par le serveur)
Db = 1e6;% Debit binaire (=debit symbole)
Fse = floor(Fe/Db); % Nombre d'echantillons par symboles
Nfft = 1024;
Nb = 1e4; % Nombre de bits générés

%% Chaîne TX
b = randi([0,1],1,Nb);
sl = modulatePPM(b,Fse);

%% Resultats
[X, f] = Mon_Welch(sl, Nfft, Fe);
DSP_th = 0.25.*dirac(f) + pi^2/(16*Db^3).*f.^2.*sinc(f./(2*Db)).^4;
DSP_th(Nfft/2+1) = 1; % pour voir un pic représentant le dirac
f = f./10^6;
figure,
semilogy(f, X);
hold on;
semilogy(f, DSP_th);
hold off;
ylim([1e-15, 1e-5]);
legend("DSP expérimentale", "DSP théorique");
%ylabel("DSP de s_l(t)");
xlabel("fréquence en MHz");
%title("Comparaison des DSP");
grid;