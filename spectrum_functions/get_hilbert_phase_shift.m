function [ phase_shift ] = get_hilbert_phase_shift(trials, freq_min, freq_max,  SamplingInterval)
%GET_HILBERT_PHASE_SHIFT Summary of this function goes here
%   Detailed explanation goes here

phases_filtered = get_hilbert_phase(trials, freq_min, freq_max, SamplingInterval);

freq_mean  = (freq_min + freq_max)/2;
% phase_shift = circ_mean(phases_filtered,[],1);
phase_shift = round(phases_filtered./freq_mean./(2*pi)/SamplingInterval*1e6);

end

