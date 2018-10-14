function [result] = calculate_spectrum_and_ERP(trials, SamplingInterval, freqs, bl_range, condition_positions, align_ind, align_freq)
%% Spectral analysis
% all times are in [ms]
% trials = [time channels segments]

n_points = size(trials,1);
n_channels = size(trials,2);
n_segs = size(trials,3);

dt = SamplingInterval/1000;

% %% re-align by theta phase
% if nargin > 5
%     [trials, ~] = align_by_phase(trials, [], SamplingInterval, freqs, align_ind, align_freq);
% end

sub_trails = zeros(size(trials));

result = {};
result.erps = [];
result.erps_power = [];
result.power = [];
result.sub_power = [];

[spectrum_power, spectrum_phases, bl_values] = get_raw_spectrum_power(trials, bl_range);
result.power_raw = spectrum_power;
result.phases = spectrum_phases;
for kk=1:max(condition_positions)
    result_condition = calculate_condition_erp_sub(trials(:,:,condition_positions == kk));
    result.erps(:,kk) = result_condition.erps;
    result.erps_power(:,:,kk) = result_condition.erps_power;
    sub_trails(:,:,condition_positions==kk) = result_condition.sub_trials;
    result.power(:,:,kk) = 10 * log10(bsxfun(@rdivide,mean(spectrum_power(:,:,:,condition_positions == kk),4),bl_values));
end
    
result.sub_trails = sub_trails;
[spectrum_power, spectrum_phases, bl_values] = get_raw_spectrum_power(sub_trails, bl_range);
result.sub_power_raw = spectrum_power;
result.sub_phases = spectrum_phases;

for kk=1:max(condition_positions)
    result.sub_power(:,:,kk) = 10 * log10(bsxfun(@rdivide,mean(spectrum_power(:,:,:,condition_positions == kk),4),bl_values));
end


    function result = calculate_condition_erp_sub(trials)
        
        n_segs = size(trials,3);
        
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
              
        % ERP
        erps_freq_power = getPowerSpectra(erps,dt, freqs); %freq-time-segments
        % erps_freq_power = shiftdim(erps_freq_power,2); %channel-freq-time
        
        
        result = {};
        result.erps = erps;
        result.erps_power = erps_freq_power;
        result.sub_trials = sub_trials;
        
    end

    function [all_freq_power, all_phases, bl_values] = get_raw_spectrum_power(trials, bl_range)

    all_freq_power = zeros([n_channels length(freqs) n_points, size(trials,ndims(trials))]);
    all_phases = all_freq_power;
    for ii = 1:n_channels
        [power,phases] = getPowerSpectra(squeeze(trials(:,ii,:))',dt, freqs);
        all_freq_power(ii,:,:,:) = power;
        all_phases(ii,:,:,:) = phases;
    end
    bl_values = mean(mean(all_freq_power(:, :, bl_range, :),4),3);

end

end