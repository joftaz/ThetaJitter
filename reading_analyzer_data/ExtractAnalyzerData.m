%% Extracy Analyzer Data
% read csv data
% segment 
tStart = tic;

%% folder and file name
ExportFolder = 'L:\Experiments\Matrix\MatrixV05\Data\EEG\Export - Yoni\';
% ExportFolder = 'E:\Study\Google Drive (Study)\theta-project\raw_data\Matrix05\';
FileName = 'Raw Data Inspection';
channel_name = 'FCz';

key = 'Raw Data Inspection';
% key = 'Raw Data Inspection';
fnames = dir([ExportFolder '*' key '.dat']);
N_subjects = length(fnames);
subjects = cell([1,N_subjects]);
results = cell([1,N_subjects]);
% for k=1:length(fnames)
for k=1:1
    fname = fnames(k).name;
    FileName = fname(1:end-4);
    subjects{k} = fname(1:end-length(key)-5);
    
    %% read csv data
    % Description of first code block
    
    datFile = [ExportFolder FileName '.dat'];
    VMRKfile = [ExportFolder subjects{k} '_Raw Data Inspection' '.vmrk'];
    VHDRfile = [ExportFolder FileName '.vhdr'];
    
    [allData] = read_analyzer_UnsegmentedData(datFile);
    [metaData] = read_vhdr_commoninfos2(VHDRfile);
    [channel_names] = cellstr(read_vhdr_channels(VHDRfile));
    [eventsCodesIndexes, artifactsIndexes]=read_markers_artifacts(VMRKfile);%check that this is the row of Mk1 indeed
    fclose('all');
    
    %% Segment by event codes
    tmin = -1000; % min-max [ms]
    tmax = 1500; % min-max [ms]
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
    all_trigs = [lose_lose_trigs, gain_gain_trigs, gain_lose_trigs, lose_gain_trigs];
    all_trigs_cells = {lose_lose_trigs, gain_gain_trigs, gain_lose_trigs, lose_gain_trigs};
    [~, trials, ~] = SegAndAvg(allData, all_trigs, window,'reject', artifactsIndexes);

    % if you want to normalize data by a baseline row (electrode)
    % SEGS = bsxfun(@minus,SEGS,mean(SEGS(bsl,:,:),1));
    
    %% collecting spectral data
    channels = {'FCz'};
    [~,~,ichannels] = intersect(channels,channel_names);
    trials = trials(:,ichannels,:);
    
    
    freqs = logspace(log10(2), log10(60), 30);
%     phase_intervals = round(((-200:50:800) - tmin)*srate);
    phase_intervals = round((-400-tmin)*srate):(1000-tmin)*srate;
    norm_times = [-300, -100] - tmin;
    bl_range = round(norm_times(1)*srate):norm_times(2)*srate;
    condition_names = {'ll','gg','gl','lg'};
    
    step_result = calculate_spectrum_and_ERP(trials, SamplingInterval, freqs, phase_intervals, bl_range, [], []);
    subject_original_bl_values = mean(step_result.originals_power(:,:,bl_range),3);
    subject_subtrials_bl_values = mean(step_result.subtrials_power(:,:,bl_range),3);
    for cond_ii = 1:length(condition_names)
        [~, trials, ~] = SegAndAvg(allData, all_trigs_cells{cond_ii}, window,'reject', artifactsIndexes);
        trials = trials(:,ichannels,:);
        cond_name = condition_names{cond_ii};
        step_result.(cond_name ) = calculate_spectrum_and_ERP(trials, SamplingInterval, freqs, phase_intervals, bl_range, subject_original_bl_values, subject_subtrials_bl_values );
    end
    results{k} = step_result;

end
tElapsed = toc(tStart)
clear allData trials step_result

%% aggragate results:
% power
zeros_func = @(name) zeros(size(results{1}.(name)));
total = struct();
total.erps = zeros_func('erps');
total.subject_erps_power = zeros_func('erps_power');
total.originals_power = zeros_func('originals_power');
total.subtrials_power = zeros_func('subtrials_power');
total.norm_subj_originals_power = zeros_func('norm_subj_originals_power');
total.norm_subj_subtrials_power = zeros_func('norm_subj_subtrials_power');
total.norm_trial_originals_power = zeros_func('norm_trial_originals_power');
total.norm_trial_subtrials_power = zeros_func('norm_trial_subtrials_power');

for i = 1:length(results)
   total.erps = total.erps + results{i}.erps / length(results);
   total.subject_erps_power = total.subject_erps_power + results{i}.erps_power / length(results);
   total.originals_power = total.originals_power + results{i}.originals_power / length(results);
   total.subtrials_power = total.subtrials_power + results{i}.subtrials_power / length(results);
   total.norm_subj_originals_power = total.norm_subj_originals_power + results{i}.norm_subj_originals_power / length(results);
   total.norm_subj_subtrials_power = total.norm_subj_subtrials_power + results{i}.norm_subj_subtrials_power / length(results);
   total.norm_trial_originals_power = total.norm_trial_originals_power + results{i}.norm_trial_originals_power / length(results);
   total.norm_trial_subtrials_power = total.norm_trial_subtrials_power + results{i}.norm_trial_subtrials_power / length(results);
end

% norm total by all subjects*trails
power_norm_func = @(X) 10*log10(bsxfun(@rdivide,X,mean(X(:,:,bl_range),3)));
total.norm_all_erps_power = getPowerSpectra(total.erps, SamplingInterval./1000, freqs, [], bl_range);
total.erps_power = getPowerSpectra(total.erps, SamplingInterval./1000, freqs);
total.norm_all_originals_power = power_norm_func(total.originals_power);
total.norm_all_subtrials_power = power_norm_func(total.subtrials_power);

% % create diffs
% total.originals_diff = total.originals_power - total.subtrials_power;
% total.norm_subj_diff = total.norm_subj_originals_power - total.norm_subj_subtrials_power;
% total.norm_trial_diff = total.norm_trial_originals_power - total.norm_trial_subtrials_power;

% phases
total.original_phases = [];
total.subtrials_phases = [];
total.originals_mean_phases = zeros_func('originals_mean_phases');
total.subtrials_mean_phases = zeros_func('subtrials_mean_phases');
total.originals_var_phases = zeros_func('originals_var_phases');
total.subtrials_var_phases = zeros_func('subtrials_var_phases');
total.originals_diff_phases = zeros_func('originals_diff_phases');
total.subtrials_diff_phases = zeros_func('subtrials_diff_phases');

for i = 1:length(results)
    total.original_phases = cat(4, total.original_phases, results{i}.original_phases);
    total.subtrials_phases = cat(4, total.subtrials_phases, results{i}.subtrials_phases);
    total.originals_mean_phases = total.originals_mean_phases + results{i}.originals_mean_phases / length(results);
    total.subtrials_mean_phases = total.subtrials_mean_phases + results{i}.subtrials_mean_phases / length(results);
    total.originals_var_phases = total.originals_var_phases + results{i}.originals_var_phases / length(results);
    total.subtrials_var_phases = total.subtrials_var_phases + results{i}.subtrials_var_phases / length(results);
    total.originals_diff_phases = total.originals_diff_phases + results{i}.originals_diff_phases / length(results);
    total.subtrials_diff_phases = total.subtrials_diff_phases + results{i}.subtrials_diff_phases / length(results);
end

%% some more metadata
meta = struct();
meta.tmin = tmin; 
meta.tmax = tmax; 
meta.SamplingInterval=SamplingInterval; %[us]
meta.srate = srate;
meta.window = window;
meta.freqs = freqs;
meta.channel_names = channel_names;
meta.t = window/srate;
meta.phase_intervals = phase_intervals;

%% save results (again)
tic
save('saved_results.mat', 'total', 'meta', '-v7.3');
save('saved_subject_results_home.mat', 'results', '-v7.3')
toc

%% display results
% displayTableSpectra(total, meta, 'trial', 'Oz', 'surf')
% showPolarTable(total, meta, 'original', 'Oz', 8,-200:50:800)

%% display results
ERPfigure;

ha = tight_subplot(length(results),1,0);
for ii = 1:length(results)

    %     subplot(length(results),1,ii)
    axes(ha(ii));
    
    times = meta.window/meta.srate;
    u = times > - 200 & times < 1000;
    t = times(u);
    freqs = meta.freqs;
	original_power = results{ii}.norm_subj_originals_power;
    original_power = squeeze(original_power(1,:,u));
    args = {t,freqs,original_power};
%     yyaxis left
    pcolor(args{:})%,'edgecolor','none');
    view(0,90);
    axis tight;
    shading interp; %colormap(parula(128));

    hold on
%     yyaxis right
    mx = max(results{ii}.erps(3,u));
    mn = min(results{ii}.erps(3,u));
    erp = ((results{ii}.erps(3,u) + mn)/(mx-mn)+1)*60;
    plot(t, erp, 'linewidth',2,'color','k');

%     displayTableSpectra(results{ii}, meta, 'trial', 'Oz', 'surf')
    ylabel(ii)
    %     set(gca,'XTick',[]);
    %     caxis([min(trials(:)), max(trials(:))])
end

xlabel time[ms]
set(gca,'XTickMode', 'auto')

axes(ha(1))
title(['trials with ERPs for all subjects with condition of: ' condition])

% ERPfigure;
% erp_trials_plot(t, alltrials, true)
% ylabel [Au]
% xlabel 'time [ms]'
% title(['all data in one place (condition: ' condition])

%% Plotting ERPs
  
% plotting Fz, Pz and FCz
%     channels = {'Fz', 'Pz', 'FCz'};
%     t = window / srate;
%     
%     ERPfigure
%     hold all
%     for ch = channels
%         ch_segs = squeeze(SEGS(:,strcmp(channel_names, ch),:));
%         varplot(t,ch_segs);
%     end
%     
%     xlabel t[ms]
%     ylabel Power[Au]
%     title(['ERP of channels: ' strjoin(channels, ', ') 'in file' FileName])
%     legend(channels )
%     
%     hold off
%     

