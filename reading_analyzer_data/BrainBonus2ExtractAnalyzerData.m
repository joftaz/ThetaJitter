%% Extracy Analyzer Data
% read csv data
% segment

%% folder and file name
ExportFolder = 'E:\Study\Google Drive (Study)\theta-project\raw_data\BrainBonus2\';
% ExportFolder = 'D:\Yoni\Google Drive\theta-project\raw_data\BrainBonus2\';
FileName = 'Raw Data Inspection';
channel_name = 'FCz';

key = 'Raw Data Inspection';
% key = 'Data Inspection_laplace';
fnames = dir([ExportFolder '*' key '.dat']);
N_subjects = length(fnames);
subjects = cell([1,N_subjects]);
results = cell([1,N_subjects]);
start_script = tic;
for sub_ind=1:length(fnames)
    fname = fnames(sub_ind).name;
    FileName = fname(1:end-4);
    subjects{sub_ind} = fname(1:end-length(FileName)-1);
    
    %% read csv data
    % Description of first code block
    
    datFile = [ExportFolder FileName '.dat'];
    VMRKfile = [ExportFolder subjects{sub_ind} '_Raw Data Inspection' '.vmrk'];
    VHDRfile = [ExportFolder FileName '.vhdr'];
    
    [allData] = read_analyzer_UnsegmentedData(datFile);
    [metaData] = read_vhdr_commoninfos2(VHDRfile);
    [channel_names] = cellstr(read_vhdr_channels(VHDRfile));
    [eventsCodesIndexes, artifactsIndexes]=read_markers_artifacts(VMRKfile);%check that this is the row of Mk1 indeed
    FCz = allData(:,strcmp(channel_name,channel_names));
    allData = FCz - mean(allData(:,~strcmp(channel_name,channel_names)),2);
    
    %% Segment by event codes
    tmin = -1000; % [ms]
    tmax = +1500; % [ms]
    SamplingInterval=metaData.SamplingInterval; %[us]
    srate = 1000/SamplingInterval;
    window = round(tmin*srate):round(tmax*srate);
    
    lose_lose_trigs = conditional_trigs(eventsCodesIndexes, 112);
    gain_gain_trigs = conditional_trigs(eventsCodesIndexes, 114);
    gain_lose_trigs = conditional_trigs(eventsCodesIndexes, 111);
    lose_gain_trigs = conditional_trigs(eventsCodesIndexes, 113);
    %     all_trigs = [lose_lose_trigs; gain_gain_trigs; gain_lose_trigs; lose_gain_trigs];
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
save('../Data/results_BrainBonus2_Laplace.mat','-v7.3')

recollect_data

%% Example for Plotting ERPs
% v=freqs<70;
% beta_logistic_regression(results, - 4,4, u, v, t, freqs, true, true)
% v=freqs<15;
% beta_logistic_regression(results,  -4,4, u, v, t, freqs, true, true)

% times = window/srate;
% u = times > - 200 & times < 1000;
% t = times(u);
% helperCWTTimeFreqPlot(squeeze(step_result.gg.originals_power(5,:,u)), t, freqs, 'contourf')
