function [codeType markers timepoints timepoints_ms howMany]=readMarkerFile(filename,sampRate)
% accepts a *.Marker file and returns the contents of a file
% INPUT:
%  - filename - the *.Marker file
%  - sampRate - the sampling rate of the data

% OUTPUT:

%  - codeType - cell array of marker types 
%  - markers - cell array of marker codes 
%  - timepoints - array of marker times in datapoints 
%  - timepoints_ms - array of marker times in milliseconds 
%  - howMany - array of how long (number of samples) each marker is (for bad interval markers, usually >1)
%
formatStr = '%s %s %f %f %*s';
fid=fopen(filename);
inputMarkers = textscan(fid, formatStr,'headerlines',2,'delimiter',',');
fclose(fid);
%nmarkers=length(inputMarkers{1});

codeType = inputMarkers{1};
markers = inputMarkers{2};
timepoints =inputMarkers{3};
howMany = inputMarkers{4};
timepoints_ms = round(timepoints*1000/sampRate);

