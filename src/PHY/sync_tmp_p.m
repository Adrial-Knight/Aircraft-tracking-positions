function [delta_max, rho_max] = sync_tmp_p(rl,sp, threshold)
    norm_sp = sum(sp.^2);
    taille_preambule = length(sp);

    [rhos, index] = xcorr(rl, sp);
    rhos = rhos(index >= 0);
    rhos = rhos(1: length(rhos) - length(sp));
    N = length(rhos);
    
    rho_local = 0;
    nb = 1;
    rho_max = [0];
    delta_max = [0];
    
    for i = 1:N
        rho_local = rhos(i)/(sqrt(sum(rl(i : i+taille_preambule-1).^2)) * sqrt(norm_sp));
        if (rho_local > threshold) && (i - delta_max(nb) >= taille_preambule)
            rho_max = [rho_max rho_local];
            delta_max = [delta_max i-1];
            nb = nb + 1;
        elseif (rho_max(nb) < rho_local) && (i - delta_max(nb) < taille_preambule)
            rho_max(nb) = rho_local;
            delta_max(nb) = i-1;
        end
    end 
end

