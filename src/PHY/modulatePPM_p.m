function modSig = modulatePPM_p(sig, Fse)
    p = [ -.5 * ones(1,Fse/2) .5 * ones(1, Fse/2) ];
    N = length(sig);
    modSig = zeros(1, N * Fse);
    for i = 1:N
        A = -sig(i) * 2 + 1;
        modSig((i-1)*Fse+1:i*Fse) = (A * p) + .5;
    end
end