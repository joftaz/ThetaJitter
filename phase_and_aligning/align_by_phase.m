function [trials, phase_shift] = align_by_phase(trials, channel_phases, SamplingInterval, freqs, start_index_phase, freq_index)

n_channels = size(trials,2);

dt = SamplingInterval/1000;
for ii = 1:n_channels
    if isempty(channel_phases)
        [~,phases] = getPowerSpectra(squeeze(trials(:,ii,:))',dt, freqs);
    else
        phases = squeeze(channel_phases(ii, :, :, :));
    end
    phase_shift = get_phase_shift(phases, start_index_phase, freq_index, freqs, SamplingInterval);
    trials = align_trials_by_shift(trials, phase_shift);
end
end
