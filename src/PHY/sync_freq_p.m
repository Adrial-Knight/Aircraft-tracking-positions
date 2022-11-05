function [delta_f, angle_cumule] = sync_freq_p(y_l, max_delta_f, Fe)
%Calcule le décalage fréquentiel 
%   yl: signal en sortie du canal
%   delta_t: décalage temporel estimé
%   sp: préambule
%   max_delta_f: plus grande valeur que peut prendre le décalage fréquentiel
%   Fe: fréquence d'échantillonage

    t = (0:1:length(y_l)-1)/Fe;

    angle_cumule = zeros(1, 2*max_delta_f + 1);
    for delta_f = -max_delta_f:max_delta_f
        t_l = y_l .* exp(1j*2*pi*delta_f*t);
        angle_cumule(delta_f + max_delta_f + 1) = sum(abs(angle(t_l)));
    end

    [~, i] = min(angle_cumule);
    delta_f = i - max_delta_f -1;
end

