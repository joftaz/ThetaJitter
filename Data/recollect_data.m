%% permtest of the original spectrum
% take only one channel
total_powers = zeros([length(freqs), length(times), max(condition_positions), N_subjects]);
erps_powers = total_powers;
sub_powers = total_powers;
original_phases = total_powers;
sub_phases = original_phases;
total_trials = [];
total_phases = [];
total_sub_phases = [];
total_erps = zeros([size(results{1}.erps)  N_subjects]);

% take only one channel
channel_ind = 1;

for sub_ind = 1:length(subjects)
    result = results{sub_ind};
    total_powers(:,:,:,sub_ind) = squeeze(result.power);        
    sub_powers     (:,:,:,sub_ind) = squeeze(result.sub_power);  
    erps_powers(:,:,:,sub_ind) = result.erps_power;
    
    for kk = 1:max(condition_positions)
        original_phases(:,:,kk,sub_ind) = squeeze(circ_mean(result.phases(channel_ind,:,:,result.condition_positions==kk),[],4));        
    end   
    total_phases = cat(4, total_phases, result.phases);
    total_sub_phases = cat(4, total_sub_phases, result.sub_phases);
    total_trials = cat(3, total_trials, result.trials);
    total_erps(:,:,sub_ind) = result.erps;
        
end

% mean_to0_normalization = mean(original_powers(:));
% original_powers = original_powers - mean_to0_normalization;
% sub_powers = sub_powers - mean_to0_normalization;

% mean over subjects
original_power_mean = mean(total_powers,4);
sub_power_mean = mean(sub_powers,4);
total_erps_mean = mean(total_erps,3);


%% some added more stuff
norm_trials = bsxfun(@minus, total_trials, mean(total_trials(bl_range,:,:)));
subject_num_trials = ones(1,length(results));
for ii=1:length(results)
    subject_num_trials(ii) = size(results{ii}.trials, 3);
end