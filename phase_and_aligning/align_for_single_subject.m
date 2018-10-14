t_zero = 300;
freq_ind = 8:13;
subj_ind = 4;
if isvector(freq_ind)
s_t_f = sprintf('@ t = %d ms, f = %.1f-%.1f Hz', t_zero, min(freqs(freq_ind)), max(freqs(freq_ind)));
else
s_t_f = sprintf('@ t = %d ms, f = %.1f Hz', t_zero, freqs(freq_ind));
end
result = results{subj_ind };
trials = result.trials;
power = result.original_power;
phases = result.phases;
sub_power = result.sub_power;
% erp = mean(trials(:,1,:),3);
% sub_trials = bsxfun(@minus, trials, erp);
% sub_power = get_norm_spectrum_power(sub_trials, freqs, SamplingInterval./1000, bl_range);
[aligned_trials,shift] = align_by_phase(trials, phases, SamplingInterval, freqs, find(times>t_zero,1), freq_ind);
% aligned_trials = align_trials_by_shift(trials, shift);
aligned_erp = mean(aligned_trials(:,1,:),3);
sub_trials_aligned = bsxfun(@minus, aligned_trials, aligned_erp);
sub_aligned_power = get_norm_spectrum_power(sub_trials_aligned, freqs, SamplingInterval./1000, bl_range);
aligned_power = align_power_by_shift(power, shift);
ERPfigure;
subplot(1,2,1);
varplot(times, squeeze(trials(:,1,:)))
title({num2str(subj_ind), '(subj) original trials'})
subplot(1,2,2);
varplot(times, squeeze(aligned_trials(:,1,:)))
title({'aligned trials, ' s_t_f})
ERPfigure;
subplot(2,3,1);
helperCWTTimeFreqPlot(squeeze(mean(power(:,:,u,:),4)), t, freqs, 'surf', {num2str(subj_ind), '(subj) original power', s_t_f})
subplot(2,3,2);
helperCWTTimeFreqPlot(squeeze(mean(sub_power(:,:,u,:),4)), t, freqs, 'surf', {'sub power', s_t_f})
subplot(2,3,3);
helperCWTTimeFreqPlot(squeeze(mean(power(:,:,u,:),4))-squeeze(mean(sub_power(:,:,u,:),4)), t, freqs, 'surf', {'evoked power', s_t_f})
subplot(2,3,4);
helperCWTTimeFreqPlot(squeeze(mean(aligned_power(:,:,u,:),4)), t, freqs, 'surf', {'aligned power' , s_t_f})
subplot(2,3,5);
helperCWTTimeFreqPlot(squeeze(mean(sub_aligned_power(:,:,u,:),4)), t, freqs, 'surf', {'sub aligned power', s_t_f})
subplot(2,3,6);
helperCWTTimeFreqPlot(squeeze(mean(aligned_power(:,:,u,:),4))-squeeze(mean(sub_aligned_power(:,:,u,:),4)), t, freqs, 'surf', {'evoked aligned power', s_t_f})