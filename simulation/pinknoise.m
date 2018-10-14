function x = pinknoise(N, a, n_channels)

% function: y = arbssnoise(N, a, dt) 
% N - number of samples to be returned in row vector
% a - spectral slope
% y - row vector of noise samples

% For instance:
% white noise   -> a = 0;
% pink noise    -> a = -1;
% red noise     -> a = -2;
% blue noise    -> a = +1;     
% violet noise  -> a = +2;

set_default('n_channels',1);
set_default('a',-1);

% generate AWGN signal
x = randn(n_channels, N);

% calculate the number of unique fft points
NumUniquePts = ceil((N+1)/2);

% take fft of x
X = fft(x,[],2);

% fft is symmetric, throw away the second half
X = X(:,1:NumUniquePts);

% prepare a vector for spectral conditioning
n = 1:NumUniquePts;

% manipulate the left half of the spectrum so the spectral 
% amplitudes is proportional to the frequency by factor f^a
X = X.*(n.^(a/2));

% perform ifft
if rem(N, 2)            % odd N excludes Nyquist point
    
    % reconstruct the whole spectrum
    X = [X conj(X(:,end:-1:2))];
    
    % take ifft of X
    x = real(ifft(X,[],2));
    
else                    % even N includes Nyquist point
    
    % reconstruct the whole spectrum
    X = [X conj(X(:,end-1:-1:2))];
    
    % take ifft of X
    x = real(ifft(X,[],2));
    
end

% ensure zero mean value and unity standard deviation 
x = x - mean(x,2);
x = x./std(x, 1, 2);

end