%% Recollecting data from BrainBonus2 (FCz)
load results_BrainBonus2.mat
recollect_data

%% Calculate Theta phases and R statistic
theta_powers_subjects = zeros(length(times),4,20);
theta_phases_r = zeros([length(times), max(condition_positions), length(results)]);
freq_min = 4.5;
freq_max = 8;
for subj_ind = 1:length(results)
    for cond = 1:4
        theta_power_subject = get_hilbert_power(squeeze(results{subj_ind}.trials(:,1,results{subj_ind}.condition_positions == cond)), freq_min, freq_max, SamplingInterval);
        theta_powers_subjects(:,cond,subj) = mean(theta_power_subject,2);
        theta_phases_r(:,cond_ind,subj_ind) = circ_r(theta_power_subject,[],[],2);
    end
end






%% save data
fig_path = fileparts(mfilename('fullpath'));
save([fig_path '/' 'Fig9.mat'], 'total_erps','bl_range','u','t','freqs','total_powers', 'sub_powers','theta_phases_r')
