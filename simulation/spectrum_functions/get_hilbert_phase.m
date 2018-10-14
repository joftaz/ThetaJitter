function [ phases_filtered ] = get_hilbert_phase(trials, freq_min, freq_max,  SamplingInterval)
srate = 1000/SamplingInterval;

d = designfilt('bandpassiir','FilterOrder',24, ...
    'HalfPowerFrequency1',freq_min,'HalfPowerFrequency2',freq_max, ...
    'SampleRate',srate*1000);
filt_trials = filtfilt(d,squeeze(trials));

phases_filtered = angle(hilbert(filt_trials));