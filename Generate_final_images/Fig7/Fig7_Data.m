%% Recollecting data from BrainBonus2 (FCz)
load results_BrainBonus2.mat
recollect_data

%% Calculate Theta phases
theta_phases_subjects = cell(1,length(results));
freq_min = 4.5;
freq_max = 8;
for subj_ind = 1:length(results)
    theta_phases_subject = get_hilbert_phase(results{subj_ind}.trials, freq_min, freq_max, SamplingInterval);
    theta_phases_subjects{subj_ind} = theta_phases_subject;
end

%% save data
fig_path = fileparts(mfilename('fullpath'));
save([fig_path '/' 'Fig7.mat'], 'theta_phases_subjects', 'freq_max' , 'freq_min', 'SamplingInterval' ,'times')