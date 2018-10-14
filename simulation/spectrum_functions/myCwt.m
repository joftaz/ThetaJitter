function [power, freq] = myCwt(x, dt, bl_values, bl_range)

useLabFunction = true;

if useLabFunction
    %following Cohen's method
    freq = logspace(log10(2), log10(60), 30);
    c = 12;
    fs = round(1/dt*1e3);
    bl_range = 0;
    [a, ~] = morletwave(freq,c,x,fs,bl_range,'normalize', 'on', 'gpu', 'off');
    power = a.^2;
    
else
    
    X = squeeze(x);
    if isvector(X)
        X = reshape(X,[1 length(X)]);
    end
    
    dt = dt*1e-3;
    
    for ii = 1:size(X,1)
        x = X(ii,:);
        
        wavelet_type = 'morl';
        sig = struct('val',x,'period',dt);
        scales = struct('s0', 0.03, 'ds', .1, 'nb', 30, 'type', 'pow', 'pow', 3);
        
        cwtS1 = cwtft(sig, 'scales', scales, 'wavelet', wavelet_type);
        freq = scal2frq(cwtS1.scales, wavelet_type, 1);
        
        if ~exist('cfs', 'var')
            power = zeros([size(cwtS1.cfs),size(X,1)]);
        end
        power(:,:,ii) = abs(cwtS1.cfs).^2;
        
    end
    
end

if nargin > 3
    % Baseline Correction
    range = floor(bldB_range(1) / dt):floor(bldB_range(2) / dt);
    cfs = bsxfun(@rdivide,cfs,mean(cfs(:,range,:),2));
%   turn to dB:
    cfs = 10 * log10(cfs);
end