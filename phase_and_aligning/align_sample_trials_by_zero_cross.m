function align_trials = align_sample_trials_by_zero_cross(t, trials, rep, n_samples, first_region, stretch, second_region, show_res)
set_default('stretch',false)
set_default('first_region', [0,400])
set_default('second_region', [400,600])
set_default('show_res', false)

erp = squeeze(mean(trials,3));
shifts = get_shift_sample_trials_by_zero_cross(t, trials, erp, rep, n_samples, first_region, stretch, second_region, false);
sprintf('max shifts: %2g' ,t(max(abs(shifts))+1)-t(1))
align_trials = align_trials_by_shift(trials, shifts');
if show_res
    varplot(t, align_trials)
    hold on
    varplot(t, squeeze(trials))
    legend({'aligned','original'})
    hold off
    
end
end
