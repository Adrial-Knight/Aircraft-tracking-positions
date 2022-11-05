function [X, f] = Mon_Welch_p(x, Nfft, Fe)
    N = length(x);
    K = floor(N/Nfft);
    f = (-Nfft/2:1:Nfft/2-1)*Fe/Nfft;
    X = zeros(1, Nfft);
    for k = 0:K-1
        if k == K % utilisation de la périodicité pour compléter le dernier échantillon
            sample = [x(k*Nfft: len) data(1: len - k*Nfft)];
        else
            sample = x(k*Nfft + 1: (k+1)*Nfft);
        end
        X = X + abs(fft(sample)).^2;
    end
    X = X / (Fe*K*Nfft); % normalisation
    X = fftshift(X);
end

