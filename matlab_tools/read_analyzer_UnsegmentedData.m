function [allData]=read_analyzer_UnsegmentedData(varargin)

% Reads unsegmented data that was exported from analyzer.
% Export must be done using Genereic Data Export with the following parameters:
% 1. write header and marker files in text format, and data with .dat / .txt extension
% 2. Data file format should be binary, data orientation vectorized, and line delimiters should be PC format
% 3. Number format should be IEEE 32 floating point
%
% input: 1. The name of the exported data file (as string), including the .txt / .dat extension
%        2. OPTIONAL - the number of channels in the data file. If empty, it
%        will be extracted from the header file assuming it is at the
%        default row. Please check that this is the case
%
% Output: a matrix of samples X electrodes of EEG data
%
% 30.10.2014 Tamar - added display of file name that is being read
% 26.03.2017 Yoni - NumberOfChannels index fix

channelsHeader = 'NumberOfChannels=';

% get nChannels from user / header file
exportedFileName=varargin{1};
if nargin>1
    nChannels=varargin{2};
else
    fidHeader=fopen([exportedFileName(1:end-4) '.vhdr']);
    header= textscan(fidHeader,'%s' , 'delimiter', '\n'); %read first column
    headerInfo=header{1,1};
    rowForNumberOfChannels = find(strncmp(channelsHeader, headerInfo, length(channelsHeader)));
    disp(['using default row of ' num2str(rowForNumberOfChannels) ' to find number of channels in header file'])
    if ~isempty(rowForNumberOfChannels) 
        nChannels=str2double(headerInfo{rowForNumberOfChannels}(length(channelsHeader)+1:end));
    else
        error('cant find number of channels, find it in header file and input manually')
    end
        
end
clear header headerInfo

% read file
tic
fid=fopen(exportedFileName);
disp(['assuming number of channels = ' num2str(nChannels) ', please verify in header file / export node of analyzer'])
disp(['loading file ' exportedFileName]); tic; allDataVect=fread(fid,'float32');
tic; allData=reshape(allDataVect, length(allDataVect)/nChannels, nChannels);
clear('allDataVect')
disp(['loading file took ' num2str(toc)])




















