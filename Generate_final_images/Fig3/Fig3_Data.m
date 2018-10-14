%% some numbers.
%% all times are in [ms]

dt  = 2;
tmax = 1998;
tmin = -1200;
fs = 1/dt;
len_sample = floor((tmax-tmin)*fs);
t = linspace(tmin, tmax, len_sample);

noise.tscales = [200, 200];
noise.amplitude = [0.5 1];
noise.jitters = [0 40:40:220] ;
noise.jitter = 0;
% noise.randn = 0.1;
noise.pink_alpha = -2.4;

jitters = noise.jitters;
num_trails = 500;
freqs = logspace(log10(2), log10(60), 30);

bl_range = find( -900 < t & t < -750);
u = t > -200 & t < 1000;
%% generating erps data
% 

erps = zeros(length(jitters), length(t));
trials = zeros(length(jitters), num_trails, length(t));
sub_trials = trials ;
for ii = 1:length(jitters)
    noise.jitter = noise.jitters(ii) * fs;
    trials(ii,:,:) = N200matWithNoise(t, num_trails, noise);
    erps(ii,:) = mean(trials(ii,:,:));
    sub_trials(ii,:,:) = bsxfun(@minus, squeeze(trials(ii,:,:)), erps(ii,:));
end

%% spectral analysis
% calculate spectrum

originals_freq_power = zeros([length(jitters) length(freqs) length(t)]);
subtrials_freq_power = originals_freq_power;
total_phase = zeros([size(originals_freq_power), num_trails]);

erps_freq_power = getPowerSpectra(erps,dt, freqs); %freq-time(-channel)
if(ndims(erps_freq_power))==2
    %for ploting competability
    erps_freq_power = reshape(erps_freq_power,[1 size(erps_freq_power)]);
else
    erps_freq_power = shiftdim(erps_freq_power,2); %channel-freq-time
end

for ii = 1:length(jitters)
    [amp,ph] = getPowerSpectra(squeeze(trials(ii,:,:)),dt,freqs);   
    bl_values = mean(mean(amp(:, bl_range, :),3),2);
    originals_freq_power(ii,:,:) = 10 * log10(bsxfun(@rdivide,mean(amp,3),bl_values));
    total_phase(ii,:,:,:) = ph;
    
    amp = getPowerSpectra(squeeze(sub_trials(ii,:,:)),dt,freqs);
%     bl_values = mean(mean(amp(:, bl_range, :),3),2);
    subtrials_freq_power(ii,:,:) = 10 * log10(bsxfun(@rdivide,mean(amp,3),bl_values));
    
    erps_freq_power(ii,:,:) = 10 * log10(bsxfun(@rdivide,squeeze(erps_freq_power(ii,:,:)),bl_values));
end

%% save the data
fig_path = fileparts(mfilename('fullpath'));
save([fig_path '/' 'jitter_and_noise.mat'], 'originals_freq_power', 'subtrials_freq_power' , 'jitters', 'erps' ,'freqs', 'u', 't')

