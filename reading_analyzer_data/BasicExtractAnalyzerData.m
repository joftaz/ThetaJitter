%% Extracy Analyzer Data
% read csv data
% segment

%% folder and file name
ExportFolder = 'L:\Experiments\Folder-Name\';
FileName = 'File-name-without-.suffix';

%% read csv data
% Description of first code block

datFile = [ExportFolder FileName '.dat'];
VMRKfile = [ExportFolder FileName '.vmrk'];
VHDRfile = [ExportFolder FileName '.vhdr'];

[allData] = read_analyzer_UnsegmentedData(datFile);
[metaData] = read_vhdr_commoninfos2(VHDRfile);
[channel_names] = cellstr(read_vhdr_channels(VHDRfile));
[eventsCodesIndexes, artifactsIndexes]=read_markers_artifacts(VMRKfile);%check that this is the row of Mk1 indeed
    
%% Segment by event codes
tmin = -t_MIN; % [ms]
tmax = +t_MAX; % [ms]
SamplingInterval=metaData.SamplingInterval; %[us]
srate = 1000/SamplingInterval; 
window = round(tmin*srate):round(tmax*srate);

relevantTrigs = [LIST OF TRIGS];

trigs = eventsCodesIndexes(ismember(eventsCodesIndexes(:,1),relevantTrigs),2);

[AVG, SEGS, REJ] = SegAndAvg(allData, trigs, window,'reject', artifactsIndexes);

% if you want to normalize data by a baseline row (electrode)
% SEGS = bsxfun(@minus,SEGS,mean(SEGS(bsl,:,:),1));

%% Example for Plotting ERPs
% plotting Fz, Pz and FCz
channels = {'Fz', 'Pz', 'FCz'};
t = window / srate;

ERPfigure
hold all
for ch = channels 
    ch_segs = squeeze(SEGS(:,strcmp(channel_names, ch),:));
    varplot(t,ch_segs);
end

xlabel t[ms]
ylabel Power[Au]
title(['ERP of channels: ' strjoin(channels, ', ')])
legend(channels )

hold off