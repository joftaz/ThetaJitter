%% Extracy Analyzer Data
% read csv data
% segment
tStart = tic;

%% folder and file name
ExportFolder = 'L:\Experiments\Matrix\MatrixV05\Data\EEG\Export - Yoni\';
% FileName = 'MatrixV05_103_Raw Data Inspection';

fnames = dir([ExportFolder '*.dat']);
N_subjects = length(fnames);
subjects = cell([1,N_subjects]);
meta = cell([1,N_subjects]);
results = cell([1,N_subjects]);
for k=1:length(fnames)
    fname = fnames(k).name;
    FileName = fname(1:end-4);
    name_inds = strfind(fname,'_');
    subjects{k} = fname(1+name_inds(1):name_inds(2)-1);
    
    
    %% read csv data
    % Description of first code block
    
    datFile = [ExportFolder FileName '.dat'];
    VMRKfile = [ExportFolder FileName '.vmrk'];
    VHDRfile = [ExportFolder FileName '.vhdr'];
    
    [allData] = read_analyzer_UnsegmentedData(datFile);
    [metaData] = read_vhdr_commoninfos2(VHDRfile);
    [channel_names] = cellstr(read_vhdr_channels(VHDRfile));
    [eventsCodesIndexes, artifactsIndexes]=read_markers_artifacts(VMRKfile);%check that this is the row of Mk1 indeed
    fclose('all');
    
    %% Segment by event codes
    tmin = -200; % min-max [ms]
    tmax = 1000; % min-max [ms]
    SamplingInterval=metaData.SamplingInterval; %[us]
    srate = 1000/SamplingInterval;
    window = round(tmin*srate):round(tmax*srate);
    t = window./srate;
    
    lose_lose_trigs = conditional_trigs(eventsCodesIndexes, [122,142,112,132], 110, -2700, 120, -2700);
    gain_gain_trigs = conditional_trigs(eventsCodesIndexes, [114,124,134,144], 110, -2700, 120, -2700);
    gain_lose_1_trigs = conditional_trigs(eventsCodesIndexes, [113,123,133,143], 120, -2700);
    gain_lose_2_trigs = conditional_trigs(eventsCodesIndexes, [111,121,131,141], 110, -2700);
    gain_lose_trigs = [gain_lose_1_trigs gain_lose_2_trigs];
    lose_gain_1_trigs = conditional_trigs(eventsCodesIndexes, [113,123,133,143], 110, -2700);
    lose_gain_2_trigs = conditional_trigs(eventsCodesIndexes, [111,121,131,141], 120, -2700);
    lose_gain_trigs = [lose_gain_1_trigs lose_gain_2_trigs];
    all_trigs = [lose_lose_trigs, gain_gain_trigs, gain_lose_trigs, lose_gain_trigs];
        
    trigs = all_trigs;
    [~, trials_ll, ~] = SegAndAvg(allData, lose_lose_trigs, window,'reject', artifactsIndexes);
    [~, trials_gg, ~] = SegAndAvg(allData, gain_gain_trigs, window,'reject', artifactsIndexes);
    [~, trials_gl, ~] = SegAndAvg(allData, gain_lose_trigs, window,'reject', artifactsIndexes);
    [~, trials_lg, ~] = SegAndAvg(allData, lose_gain_trigs, window,'reject', artifactsIndexes);
    trials = cat(3, trials_ll, trials_gg, trials_gl, trials_lg);
    
    norm_times = [-195, 0] - tmin;
    bl_range = round(norm_times(1)*srate):norm_times(2)*srate;
    trials = bsxfun(@minus,trials,mean(trials(bl_range,:,:),1));   
    results{k} = trials;
    
    meta{k} = struct();
    meta{k}.ll_inds = 1:size(trials_ll,3);
    meta{k}.gg_inds = meta{k}.ll_inds(end)+(1:size(trials_gg,3));
    meta{k}.gl_inds = meta{k}.gg_inds(end)+(1:size(trials_gl,3));
    meta{k}.lg_inds = meta{k}.gl_inds(end)+(1:size(trials_lg,3));
    meta{k}.all_inds = 1:size(trials,3);
    
end
tElapsed = toc(tStart)
clear allData trials

%% save results (again)
tic
save('original_trials.mat', 'results', 'meta', 'channel_names', 't', 'subjects')
toc

%% load data
load('original_trials.mat')

%% display results
channel = strcmp(channel_names, 'FCz');
condition = 'all';

alltrials = [];
ERPfigure;

ha = tight_subplot(length(results),1,0);
for ii = 1:length(results)
    condition_inds = meta{ii}.([condition '_inds']);
    trials = squeeze(results{ii}(:,channel,condition_inds))';    
    alltrials = [alltrials; trials];

%     subplot(length(results),1,ii)
    axes(ha(ii));

    erp_trials_plot(t, trials ,true)
    ylabel(subjects{ii})
    %     set(gca,'XTick',[]);
    %     caxis([min(trials(:)), max(trials(:))])
end

xlabel time[ms]
set(gca,'XTickMode', 'auto')

axes(ha(1))
title(['trials with ERPs for all subjects with condition of: ' condition])

ERPfigure;
erp_trials_plot(t, alltrials, true)
ylabel [Au]
xlabel 'time [ms]'
title(['all data in one place (condition: ' condition])

%% filtering data and display
% Design and apply the bandpass filter
order    = 10;
fcutlow  = 4;
fcuthigh = 7;
% [b,a]    = butter(order,[fcutlow,fcuthigh]/(1000*srate/2), 'bandpass');

d = designfilt('bandpassiir','FilterOrder',order, ...
    'HalfPowerFrequency1',fcutlow,'HalfPowerFrequency2',fcuthigh, ...
    'SampleRate',srate*1000);

ERPfigure;

% ha = tight_subplot(length(results),1,0);
for ii = 1:length(results)
    condition_inds = meta{ii}.([condition '_inds']);
    trials = squeeze(results{ii}(:,channel,condition_inds))';   
    
    subplot(length(results),1,ii)
%     axes(ha(ii));
    filt_trials = filtfilt(d,trials')';
    erp_trials_plot(t, filt_trials ,true)

    %     set(gca,'XTick',[]);
    ylabel(ii)
    %     caxis([min(trials(:)), max(trials(:))])
end

xlabel time[ms]
set(gca,'XTickMode', 'auto')

ERPfigure;
filt_alltrials = filtfilt(d,alltrials')';
erp_trials_plot(t, filt_alltrials, true)

ylabel [Au]
xlabel 'time [ms]'
title(sprintf('filtered data with bandwidth filter of [%d,%d] Hz',fcutlow, fcuthigh))

hold on
erp = mean(alltrials,1);
erp = erp/max(erp); %norm
plot(t, erp, 'linewidth',2,'color','r');

filt_erp = filtfilt(d,erp);
plot(t, filt_erp/max(filt_erp), 'linewidth',2,'color','g');

legend({'ERP of filtered data', 'ERP of original data', 'filtered ERP of original data'})
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
