function [power, phase] = getPowerSpectra(x, dt, freq, bl_values, range)

c = 12;
fs = round(1/dt*1e3);
% [a, p] = morletwave2(freq,c,x,fs,0,'normalize', 'on', 'gpu', 'off');
[a, p] = morletwave(freq,c,x,fs,0,'normalize', 'on', 'gpu', 'off','waitbar','off');

power = a.^2;
phase = p;

% Baseline Correction

%correct by range
if nargin > 4 && ~isempty(range)
    bl_values = mean(power(:,range,:),2);
end
if nargin > 3 && ~isempty(bl_values)
    power_norm = bsxfun(@rdivide,power,bl_values);
    power = 10 * log10(power_norm);
end
