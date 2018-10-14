%% Recollecting data from BrainBonus2 (FCz)
load results_BrainBonus2.mat
recollect_data

%% Calculate Theta phases
theta_phases = [];
theta_phases_subjects = cell(1,length(results));
freq_min = 4.5;
freq_max = 8;
for subj_ind = 1:length(results)
    theta_phases_subject = get_hilbert_phase(results{subj_ind}.trials, freq_min, freq_max, SamplingInterval);
    theta_phases_subjects{subj_ind} = theta_phases_subject;
    theta_phases(subj_ind,:) = circ_mean(theta_phases_subject,[],2);
end

erp_theta_phases = [];
for subj_ind = 1:length(results)
    erp_theta_phases(subj_ind,:) = get_hilbert_phase(mean(results{subj_ind}.trials,3), freq_min, freq_max, SamplingInterval);
end

%% save data
fig_path = fileparts(mfilename('fullpath'));
save([fig_path '/' 'Fig6.mat'], 'theta_phases', 'erp_theta_phases', 'freq_max' , 'freq_min', 'times')
