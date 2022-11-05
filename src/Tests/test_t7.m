clear
close all
clc

addpath('../MAC');
addpath('../PHY');
addpath('../General');
addpath('../../data');

%% Parameters
REF_LON = -0.606629; % Longitude de l'ENSEIRB-Matmeca
REF_LAT = 44.806884; % Latitude de l'ENSEIRB-Matmeca
msgs = load('bits_vitesse.mat').bits_vitesse;
%%
n = width(msgs);
for i=1:n
    m = msgs(:,i)';
    reg = bit2registre(m, REF_LON, REF_LAT);
    speed = sqrt(reg.heading_NS^2 + reg.heading_EW^2);
    disp(reg.address);
    disp(speed);
end