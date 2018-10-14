function [eventsCodesIndexes, artifactsIndexes]=read_markers_artifacts(varargin)

% Read a given markers file (*.vmrk) exported from Analyzer 
% 
% input: 1. The name of the exported markers file (as string), including the .vmrk extension
%        2. OPTIONAL - the row number in the marker file of the first marker (Mk1=...).
%           If empty, it will be extracted from the header file assuming it is at the 
%           default row. Please check that this is the case
%
%
% Output: 1. eventsCodesIndexes: a matrix of nEvents X 2, each row containing code and index 
%            for events that are tagged in the file as 'Stimulus'. Indexes are for the samples in
%            the matrix of unsegmented EEG data (samples X electrodes)
%         2. artifactsIndexes: a vector with all the indexes of artifacts, identified as events
%            that are tagged in the file as 'Bad Interval'


%%
defaultRowForFirstMarker=15; % from Analyzer marker file - the row of the first marker (Mk1) is 15

VMRKfileName=varargin{1};

if nargin>1
    headerlines=varargin{2}-1;
else
    headerlines=defaultRowForFirstMarker-1;
end

fidMarkers=fopen(VMRKfileName);
markers = textscan(fidMarkers,'%s %s %f %f %*s' ,'headerLines',headerlines, 'delimiter', ','); 

firstMarkerType=markers{1,1}{1};
if ~strcmp(firstMarkerType(1:4),'Mk1=')
    if nargin>1
        error('Second input variable, indicating first row of markers, is incorrect - check marker file again')
    else
        error(['first row of markers is not at default line ' num2str(defaultRowForFirstMarker) ', check marker file and insert correct row number manually'])
    end
end

markerTypes=markers{1,1};
markerCodes=markers{1,2};
markerPositions=markers{1,3};
markerLengths=markers{1,4};

markerPositions=markerPositions(min(strmatch('S254',markerCodes)):end);
markerLengths=markerLengths(min(strmatch('S254',markerCodes)):end);

artifactsLocations=markerPositions(markerLengths>10);
artifactsLengths=markerLengths(markerLengths>10);

artifactsIndexes=[];
for i=1:length(artifactsLocations)
    artifactsIndexes=[artifactsIndexes; (artifactsLocations(i):artifactsLocations(i)+artifactsLengths(i))'];
end
artifactsIndexes=unique(artifactsIndexes);


markerPositions=markers{1,3};
eventsCodesIndexes=[];
for ii=1:length(markerCodes)
    if strcmp(markerTypes{ii}(end-7:end), 'Stimulus') && ~strcmp(markerCodes{ii}, 'New Marker') && ~strcmp(markerCodes{ii}, 'ICA')
        eventsCodesIndexes=[eventsCodesIndexes; [str2num(markerCodes{ii}(2:end)), markerPositions(ii)]];
    end
end

%%

