%% Extracy Analyzer Data
% read csv data
% segment

%% folder and file name
ExportFolder = 'E:\Study\Google Drive (Study)\theta-project\raw_data\Matrix05\';
% ExportFolder = 'D:\Yoni\Google Drive\theta-project\raw_data\Matrix05\';
% ExportFolder = 'L:\Experiments\Matrix\MatrixV05\Data\EEG\Export - Yoni\';
FileName = 'Raw Data Inspection';
channel_name = 'FCz';

% key = 'Raw Data Inspection';
key = 'RDI Gradient';
fnames = dir([ExportFolder '*' key '.dat']);
N_subjects = length(fnames);
subjects = cell([1,N_subjects]);
results = cell([1,N_subjects]);
start_script = tic;
for sub_ind=1:length(fnames)
    fname = fnames(sub_ind).name;
    FileName = fname(1:end-4);
    subjects{sub_ind} = fname(1:end-length(key)-5);
    
    %% read csv data
    % Description of first code block
    
    datFile = [ExportFolder FileName '.dat'];
    VMRKfile = [ExportFolder subjects{sub_ind} '_Raw Data Inspection' '.vmrk'];
    VHDRfile = [ExportFolder FileName '.vhdr'];
    
    [allData] = read_analyzer_UnsegmentedData(datFile);
    [metaData] = read_vhdr_commoninfos2(VHDRfile);
    [channel_names] = cellstr(read_vhdr_channels(VHDRfile));
    [eventsCodesIndexes, artifactsIndexes]=read_markers_artifacts(VMRKfile);%check that this is the row of Mk1 indeed
    allData = allData(:,strcmp(channel_name,channel_names));
    
    %% Segment by event codes
    tmin = -1000; % [ms]
    tmax = +1500; % [ms]
    SamplingInterval=metaData.SamplingInterval; %[us]
    srate = 1000/SamplingInterval;
    window = round(tmin*srate):round(tmax*srate);
    
    lose_lose_trigs = conditional_trigs(eventsCodesIndexes, [122,142,112,132], 110, -2700, 120, -2700);
    gain_gain_trigs = conditional_trigs(eventsCodesIndexes, [114,124,134,144], 110, -2700, 120, -2700);
    gain_lose_1_trigs = conditional_trigs(eventsCodesIndexes, [113,123,133,143], 120, -2700);
    gain_lose_2_trigs = conditional_trigs(eventsCodesIndexes, [111,121,131,141], 110, -2700);
    gain_lose_trigs = [gain_lose_1_trigs gain_lose_2_trigs];
    lose_gain_1_trigs = conditional_trigs(eventsCodesIndexes, [113,123,133,143], 110, -2700);
    lose_gain_2_trigs = conditional_trigs(eventsCodesIndexes, [111,121,131,141], 120, -2700);
    lose_gain_trigs = [lose_gain_1_trigs lose_gain_2_trigs];
%     all_trigs = [lose_lose_trigs, gain_gain_trigs, gain_lose_trigs, lose_gain_trigs];
%     all_trigs_cells = {lose_lose_trigs, gain_gain_trigs, gain_lose_trigs, lose_gain_trigs};
    
    [~, ll_trials, ~] = SegAndAvg(allData, lose_lose_trigs, window,'reject', artifactsIndexes);
    [~, lg_trials, ~] = SegAndAvg(allData, lose_gain_trigs, window,'reject', artifactsIndexes);
    [~, gl_trials, ~] = SegAndAvg(allData, gain_lose_trigs, window,'reject', artifactsIndexes);
    [~, gg_trials, ~] = SegAndAvg(allData, gain_gain_trigs, window,'reject', artifactsIndexes);
    
    % if you want to normalize data by a baseline row (electrode)
    % SEGS = bsxfun(@minus,SEGS,mean(SEGS(bsl,:,:),1));
    
    %% collecting spectral data 
    freqs = logspace(log10(2), log10(60), 30);
    norm_times = [-300, -100] - tmin;
    bl_range = round(norm_times(1)*srate):norm_times(2)*srate;
    condition_names = {'ll','lg', 'gl', 'gg'};
    
    condition_lengths=[1,size(ll_trials,2),size(lg_trials,2),size(gl_trials,2),size(gg_trials,2)];
    condition_positions = [];
    condition_positions(cumsum(condition_lengths))=1;
    condition_positions = cumsum(condition_positions(1:end-1));
    
    trials = [ll_trials , lg_trials, gl_trials, gg_trials];
    trials = reshape(trials, size(trials,1),1,size(trials,2));
   
    step_result = calculate_spectrum_and_ERP(trials, SamplingInterval, freqs, bl_range, condition_positions);
    step_result.condition_positions = condition_positions;
    step_result.trials = trials;
    
    results{sub_ind} = step_result;
end
toc(start_script )

times = window/srate;
u = times > - 200 & times < 1000;
t = times(u);
v=freqs<70;

%% load results
% load('results.mat')

%% saving results
save('../Data/results_Matrix05.mat','-v7.3')

% %% permtest of the original spectrum
% % take only one channel
% original_power = zeros([length(freqs), length(times), max(condition_positions), N_subjects]);
% sub_power = original_power;
% original_phases = original_power;
% total_phases = [];
% total_sub_phases = [];
% channel_ind = 1;
% permtest
% for sub_ind = 1:length(subjects)
%     result = results{sub_ind};
%     for kk = 1:max(condition_positions)
%         original_power(:,:,kk,sub_ind) = squeeze(mean(result.original_power(channel_ind,:,:,result.condition_positions==kk),4));        
%         sub_power     (:,:,kk,sub_ind) = squeeze(mean(result.sub_power     (channel_ind,:,:,result.condition_positions==kk),4));        
%         original_phases(:,:,kk,sub_ind) = squeeze(mean(result.phases(channel_ind,:,:,result.condition_positions==kk),4));        
%         
%     end
%     total_phases = cat(4, total_phases, result.phases);
%     total_sub_phases = cat(4, total_phases, result.phases);
% end
% % mean over subjects
% original_power_mean = mean(original_power,4);
% sub_power_mean = mean(sub_power,4);
% % erp_beta_mean = mean(erp_beta,3);
% 
% %%  permtest of the original ERPS
% original_erps = zeros([size(results{1}.erps)  N_subjects]);
% 
% for sub_ind = 1:length(subjects)
%     result = results{sub_ind};
%     original_erps(:,:,sub_ind) = result.erps;
% end
% original_erps_mean = mean(original_erps,3);
% 
% %% align trials
% t_zero = 200;
% freq_ind = 8:13;
% aligned_erps = zeros([length(times) max(condition_positions) N_subjects]);
% 
% for sub_ind = 1:length(subjects)
%     result = results{sub_ind };
%     trials = result.trials;
%     power = result.original_power;
%     phases = result.phases;
% 
%     sub_power = result.sub_power;
%     % erp = mean(trials(:,1,:),3);
%     % sub_trials = bsxfun(@minus, trials, erp);
%     % sub_power = get_norm_spectrum_power(sub_trials, freqs, SamplingInterval./1000, bl_range);
% 
%     [aligned_trials,shift] = align_by_phase(trials, phases, SamplingInterval, freqs, find(times>t_zero,1), freq_ind);
%     % aligned_trials = align_trials_by_shift(trials, shift);
%     aligned_subj_erps = mean(aligned_trials(:,1,:),3);
%     sub_trials_aligned = bsxfun(@minus, aligned_trials, aligned_subj_erps);
%     result.sub_aligned_power = get_norm_spectrum_power(sub_trials_aligned, freqs, SamplingInterval./1000, bl_range);
%     result.aligned_power = align_power_by_shift(power, shift);
%     result.shift = shift;
%     results{sub_ind} = result;
% 
%     for kk = 1:max(condition_positions)
%         aligned_erps(:,kk,sub_ind) = squeeze(mean(aligned_trials(:,1,result.condition_positions==kk),3));           
%     end
%     
% end
% 
% %% aggregate aligned
% aligned_power = zeros([length(freqs), length(times), max(condition_positions), N_subjects]);
% sub_aligned_power = aligned_power;
% 
% channel_ind = 1;
% 
% for sub_ind = 1:length(subjects)
%     result = results{sub_ind};
%     for kk = 1:max(condition_positions)
%         aligned_power(:,:,kk,sub_ind) = squeeze(mean(result.aligned_power(channel_ind,:,:,result.condition_positions==kk),4));        
%         sub_aligned_power(:,:,kk,sub_ind) = squeeze(mean(result.sub_aligned_power(channel_ind,:,:,result.condition_positions==kk),4));        
%     end
% end
% % mean over subjects
% aligned_power_mean = mean(original_power,4);
% sub_aligned_power_mean = mean(sub_aligned_power,4);
% 
% %% Example for Plotting ERPs
% % v=freqs<70;
% % beta_logistic_regression(results, - 4,4, u, v, t, freqs, true, true)
% % v=freqs<15;
% % beta_logistic_regression(results,  -4,4, u, v, t, freqs, true, true)
% 
% % times = window/srate;
% % u = times > - 200 & times < 1000;
% % t = times(u);
% % helperCWTTimeFreqPlot(squeeze(step_result.gg.originals_power(5,:,u)), t, freqs, 'contourf')
