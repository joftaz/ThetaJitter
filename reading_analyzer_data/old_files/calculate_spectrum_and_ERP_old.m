function [result] = calculate_spectrum_and_ERP(trials, SamplingInterval, freqs, phase_intervals, bl_range, original_bl_values, subtrials_bl_values)
%% Spectral analysis 
% all times are in [ms]
% trials = [time channels segments]

n_points = size(trials,1);
n_channels = size(trials,2);
n_segs = size(trials,3);
% 
dt = SamplingInterval/1000;
% [~,phases] = getPowerSpectra(squeeze(trils(:,1,:))',dt, freqs);
% original_phases_diff = diff(phases,1,2);
% min_phases=zeros(size(phases,1),size(phases,3));
% for ii = 1:size(min_phases,1)
%     for jj = 1:size(min_phases,2)
%         min_phases(ii,jj) = find(original_phases_diff(ii, 258:end, jj) < -1,1);
%     end
% end
% phase_shift = min_phases(11,:);
% for jj = 1:length(phase_shift)
%     trials(:,1,jj) = circshift(trials(:,1,jj), -phase_shift(jj));
% end


%% calc erps data
erps = mean(trials,3)';

%% Subtracting ERPs
sub_trials = zeros(size(trials));
for ii = 1:n_channels
    for jj = 1:n_segs
        %         sub_trials(ii,,:) = bsxfun(@minus, trials(ii,:,:), erps(ii,:)');
        sub_trials(:,ii,jj) = squeeze(trials(:,ii,jj)) - erps(ii,:)';
    end
end

%% spectral analysis
dt = SamplingInterval/1000;

originals_freq_power = zeros([n_channels length(freqs) n_points]);
subtrials_freq_power = originals_freq_power;
norm_subj_originals_power = originals_freq_power;
norm_subj_subtrials_power = subtrials_freq_power;
originals_phases = zeros([n_channels, length(freqs), length(phase_intervals), n_segs]);
subtrials_phases = originals_phases;
originals_mean_phases = originals_freq_power;
subtrials_mean_phases = originals_mean_phases;
originals_var_phases = originals_mean_phases;
subtrials_var_phases = originals_var_phases;
originals_diff_phases = zeros([n_channels,length(freqs),n_points-1]);
subtrials_diff_phases = originals_diff_phases;

% ERP
erps_freq_power = getPowerSpectra(erps,dt, freqs); %freq-time-segments
% erps_freq_power = shiftdim(erps_freq_power,2); %channel-freq-time

% trials
for ii = 1:n_channels
    [power,phases] = getPowerSpectra(squeeze(trials(:,ii,:))',dt, freqs);
    originals_freq_power(ii,:,:) = mean(power,3);
    norm_subj_originals_power(ii,:,:) = geomean(power,3);
    originals_phases(ii,:,:,:) = phases(:,phase_intervals,:);
    originals_mean_phases(ii,:,:) = mean(phases, 3);
    originals_var_phases(ii,:,:) = var(phases,0,3);
    originals_diff_phases(ii,:,:) = mean(mod(diff(phases,1,2),2*pi),3);
    
    [power,phases] = getPowerSpectra(squeeze(sub_trials(:,ii,:))',dt, freqs);
    subtrials_freq_power(ii,:,:) = mean(power,3);
    norm_subj_subtrials_power(ii,:,:) = geomean(power,3);
    subtrials_phases(ii,:,:,:) = phases(:,phase_intervals,:);
    subtrials_mean_phases(ii,:,:) = mean(phases, 3);
    subtrials_var_phases(ii,:,:) = var(phases,0,3);
    subtrials_diff_phases(ii,:,:) = mean(mod(diff(phases,1,2),2*pi),3);

end

% norm each trial by all conditions (for each subject) prestimulus.
if isempty(original_bl_values)
    original_bl_values = mean(originals_freq_power(:,:,bl_range),3);
    subtrials_bl_values = mean(subtrials_freq_power(:,:,bl_range),3);
end
norm_subj_originals_power = 10 * log10(bsxfun(@rdivide,norm_subj_originals_power,original_bl_values ));
norm_subj_subtrials_power = 10 * log10(bsxfun(@rdivide,norm_subj_subtrials_power,subtrials_bl_values ));
    
result = {};
result.erps = erps;
result.erps_power = erps_freq_power;
result.originals_power = originals_freq_power;
result.subtrials_power = subtrials_freq_power;
result.original_phases = originals_phases;
result.subtrials_phases = subtrials_phases;
result.norm_subj_originals_power = norm_subj_originals_power;
result.norm_subj_subtrials_power = norm_subj_subtrials_power;

result.originals_mean_phases = originals_mean_phases;
result.subtrials_mean_phases = subtrials_mean_phases;
result.originals_var_phases = originals_var_phases;
result.subtrials_var_phases = subtrials_var_phases;
result.originals_diff_phases = originals_diff_phases;
result.subtrials_diff_phases = subtrials_diff_phases;

% norm each trial by it's own prestimulus.
for ii = 1:n_channels
    [power,~] = getPowerSpectra(squeeze(trials(:,ii,:))',dt, freqs, [], bl_range);
    originals_freq_power(ii,:,:) = mean(power,3);
    [power,~] = getPowerSpectra(squeeze(sub_trials(:,ii,:))',dt, freqs, [], bl_range);
    subtrials_freq_power(ii,:,:) = mean(power,3);
end
result.norm_trial_originals_power = originals_freq_power;
result.norm_trial_subtrials_power = subtrials_freq_power;

end