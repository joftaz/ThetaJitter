function [ power_filtered ] = get_hilbert_power(trials, freq_min, freq_max,  SamplingInterval)
srate = 1000/SamplingInterval;

d = designfilt('bandpassiir','FilterOrder',24, ...
    'HalfPowerFrequency1',freq_min,'HalfPowerFrequency2',freq_max, ...
    'SampleRate',srate*1000);
filt_trials = filtfilt(d,squeeze(trials));

power_filtered = abs(hilbert(filt_trials));