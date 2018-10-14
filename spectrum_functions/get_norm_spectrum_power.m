function [norm_power, all_phases] = get_norm_spectrum_power(trials, freqs, dt, bl_range)

n_points = size(trials,1);
n_channels = size(trials,2);

all_freq_power = zeros([n_channels length(freqs) n_points, size(trials,ndims(trials))]);
all_phases = all_freq_power;
for ii = 1:n_channels
    [power,phases] = getPowerSpectra(squeeze(trials(:,ii,:))',dt, freqs);
    all_freq_power(ii,:,:,:) = power;
    all_phases(ii,:,:,:) = phases;
end
bl_values = mean(mean(all_freq_power(:, :, bl_range, :),4),3);
norm_power = 10 * log10(bsxfun(@rdivide,all_freq_power,bl_values));

end