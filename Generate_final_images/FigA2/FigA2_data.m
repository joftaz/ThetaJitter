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
noise.jitters = [0 20:20:180] ;
noise.jitter = 0;
% noise.randn = 0.1;
noise.pink_alpha = -2.4;

jitters = noise.jitters;
num_trails = 1000;
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


%% save the data
fig_path = fileparts(mfilename('fullpath'));
save([fig_path '/' 'FigA2.mat'], 'trials', 'dt' , 'jitters', 't')
    