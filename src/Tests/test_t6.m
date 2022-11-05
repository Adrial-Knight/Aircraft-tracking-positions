clear
close all
clc

addpath('../MAC');
addpath('../PHY');
addpath('../General');
addpath('../../data');

%% Parameters
Fe = 4e6; % sample rate (server controlled)
Rb = 1e6; % binary rate
Fse = floor(Fe/Rb); % samples per symbol
Nfft = 1024;
msgs = load('adsb_msgs.mat').adsb_msgs';
REF_LON = -0.606629; % Longitude de l'ENSEIRB-Matmeca
REF_LAT = 44.806884; % Latitude de l'ENSEIRB-Matmeca


%%
n = height(msgs);
affiche_carte(REF_LON, REF_LAT);
hold on;
for index = 1:n
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