clear 
close all
clc

addpath('../PHY');
%% 
Fe = 20e6; % Frequence d'echantillonnage (imposee par le serveur)
Rb = 1e6;% D    ebit binaire (=debit symbole)
Fse = floor(Fe/Rb); % Nombre d'echantillons par symboles

%% Chaine TX
%b = randi([0 1], 1, 6);
b = [1 0 0 1 0];
sl = modulatePPM(b,Fse);

%% Chaine RX
b_rec = demodulatePPM(sl,Fse);

%% Affichage
subplot(2, 1, 1)
t = (0:length(sl)-1)/Fe;
plot(t * 1e6, sl)
title('s_l(t)')
grid on
ylim([-0.15, 1.15])
set(gca, 'Xtick', 0:1:6, 'XTickLabel', {'0', 'T_S', '2T_S', '3T_S', '4T_S', '5T_S', '6T_S'});
set(gca, 'Ytick', [0 1], 'YTickLabel', {'0' '1'});

subplot(2, 1, 2)
plot(1:1:5, b_rec, "sr");
title('bits décidés')
grid on
ylim([-0.15, 1.15])
set(gca, 'Xtick', 0:1:6, 'XTickLabel', {'0', 'T_S', '2T_S', '3T_S', '4T_S', '5T_S', '6T_S'});
set(gca, 'Ytick', [0 1], 'YTickLabel', {'0' '1'});

%% test de demodulate
nb_erreur = sum(b ~= b_rec);
disp(['Nombre d''erreurs observées : ', num2str(nb_erreur)])