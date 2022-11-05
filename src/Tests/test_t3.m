clear 
close all
clc

addpath('../PHY');

%% 
Nb = 88;

%% Cha�ne TX
b = randi([0,1],1,Nb);
c = encodeCRC(b);
[ ~, error_flag]  = decodeCRC(c);
disp(error_flag);
c(1) = xor(c(1), 1);
[ ~, error_flag]  = decodeCRC(c);
disp(error_flag);
