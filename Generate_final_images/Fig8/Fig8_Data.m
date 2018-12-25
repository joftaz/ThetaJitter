%% Recollecting data from BrainBonus2 (FCz)
load results_BrainBonus2.mat
recollect_data

%% Calculate Theta phases
t_min = 0;
t_max = 600;
subj_ind = 8;

result = results{subj_ind};
trials = result.trials;
trials = bsxfun(@minus, trials, mean(trials,1));
original_erp = mean(trials,3);

mask = times > t_min & times < t_max;

[~, woody_shift] = woody(squeeze(trials).*mask', [],[],'thornton','biased');
shift = woody_shift;

aligned_trials = align_trials_by_shift(trials, -shift);
aligned_erp = mean(aligned_trials,2);
sub_trials_aligned = bsxfun(@minus, aligned_trials, aligned_erp);
% sub_aligned_power = get_norm_spectrum_power(sub_trials_aligned, freqs, SamplingInterval./1000, bl_range);

sub_aligned_power = getPowerSpectra(sub_trials_aligned', SamplingInterval./1000, freqs);
sub_aligned_power = norm_power_bl_range(sub_aligned_power, bl_range);

aligned_power = getPowerSpectra(aligned_trials', SamplingInterval./1000, freqs);
aligned_power = norm_power_bl_range(squeeze(aligned_power), bl_range);

resampled_power = getPowerSpectra(squeeze(trials)', SamplingInterval./1000, freqs);
resampled_power = norm_power_bl_range(squeeze(resampled_power), bl_range);

sub_resampled_trials = bsxfun(@minus, squeeze(trials), squeeze(mean(trials,3)));
sub_power = getPowerSpectra(sub_resampled_trials', SamplingInterval./1000, freqs);
sub_power = norm_power_bl_range(sub_power, bl_range);


%% save data

fig_path = fileparts(mfilename('fullpath'));
save([fig_path '/' 'Fig8.mat'], 't', 'freqs','u', 'resampled_power','sub_power','resampled_power','aligned_power','sub_aligned_power','aligned_erp','original_erp');
