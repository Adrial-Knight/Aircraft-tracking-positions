function sig = demodulatePPM_p(packet, Fse)
    g_a = [ .5 * ones(1, Fse/2) -.5 * ones(1,Fse/2) ];
    sig = conv(packet, g_a); % matched filter
    sig = sig(Fse:Fse:length(sig)); % downsampling
    sig = (sig / max(sig)) < 0; % remap the values to bits
end