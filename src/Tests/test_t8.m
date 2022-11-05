%% init
clear;
close all;
clc;

addpath('../MAC');
addpath('../PHY');
addpath('../General');
addpath('../../data');

%% load
buff = load("data/buffers.mat").buffers;
Rs = load("data/buffers.mat").Rs;

%% paramètres
Fe = 20e6; % Frequence d'echantillonnage (imposee par le serveur)
Rb = 1e6;% Debit binaire (=debit symbole)
Fse = floor(Fe/Rb); % Nombre d'echantillons par symboles
nb_bit = 112; % nombre de bit dans un message
REF_LON = -0.606629; % Longitude de l'ENSEIRB-Matmeca
REF_LAT = 44.806884; % Latitude de l'ENSEIRB-Matmeca

%% Traitement
avion = buff(:, 5);
avion_square = abs(avion).^2;
sp = get_preamble(Fse);
size_sp = length(sp);


[delta_t, rho] = sync_tmp_p(avion_square,sp, 0.6);
nb_msg = length(delta_t);
msgs = zeros(nb_msg, nb_bit);
for i = 1:nb_msg
    trame = avion(delta_t(i)+size_sp:delta_t(i)+size_sp+Fse*nb_bit-1);
    msgs(i, :) = demodulatePPM(trame,Fse).';
end

affiche_carte(REF_LON, REF_LAT);
hold on;
for index = 1:nb_msg
    msg = msgs(index,:);
    reg = bit2registre(msg, REF_LON, REF_LAT);
    if reg.error~=1 && reg.altitude ~= -1
        plot(reg.longitude, reg.latitude, '*');
    elseif reg.error ~=1 && reg.type >= 1 && reg.type <= 4
        disp(reg.name);
    elseif reg.error ~= 1 && reg.type == 19
        disp([ reg.headding_EW reg.heading_NS ]);
    end
end
