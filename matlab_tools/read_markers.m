function markers = read_markers(VMRKfile)
% Read a given markers file (*.vmrk) exported from Analyzer 
% and returns a double column matrix of marker time points and codes.
% 
% Written  by Alon Keren 27.2.08
% Modified 4.5.08: correct for double marker 1
% Modified 27.7.08: added start marker 255 (before only 1) for subject 4
% Modified 9.9.08: Added 'New Segment' as a start point
% Modified 28.10.08: Added screening for stimuli in the code range
% Modified 9.8.09: added start marker 254 (before only 1) for subject 8 in
% GammaBinding2

% if nargin==1, fs = 1.024; end   % Default sampling frequency is 1.024 KHz
% if ~exist('fs','var')
%     fs = 1.024; % Default sampling frequency is 1.024 KHz
% end

fid = fopen(VMRKfile);
% Skip 15 header lines and read strings and numbers between commas:
mark_data = textscan(fid, '%s %s %d %d8 %d8','delimiter',',','headerLines',14);fclose(fid); % Changed 15 to 14 % 9.9.08
if size(mark_data) ~=[1 5]
    error('Unknown file format.')
end
Nmarkers = length(mark_data{1});
codes = char(mark_data{2});
% times = double(mark_data{3})/fs;
times = double(mark_data{3});
% start_marks = find(codes(:,3)==' ' & codes(:,4)=='1'); % Blocks start with marker code 1 % 17.4.08
% stop_marks = [start_marks(2:end); Nmarkers+2]; % 17.4.08
start_epochs = strmatch('Start Epoch',codes); % Markers of epoch start points % 17.4.08
Mk = char(mark_data{1});    % 9.9.08
start_epochs = [strmatch('New Segment',Mk(:,5:end)); start_epochs]; % Add New Segment as a start point % 9.9.08
%start_epochs = sort(start_epochs);      % edden 6.4.2011

Nblocks = length(start_epochs);
start_marks = ones(Nblocks,1);
for block = 1:Nblocks
    start_codes = codes(start_epochs(block)+(1:20),:);  % Changed 10 to 20 24.9.08
%     start_marks(block) = start_epochs(block) + min(strmatch('S ',start_codes));   % 4.5.08
%     last_marker_1 = max(strmatch('S  1',start_codes));  % 4.5.08  % 27.7.08
    last_marker_1 = max([strmatch('S  1',start_codes); strmatch('S255',start_codes); strmatch('S254',start_codes)]);  %27.7.08
    start_marks(block) = start_epochs(block) + last_marker_1;   % 4.5.08
end
stop_marks = [start_epochs(2:end)-1; Nmarkers];% 17.4.08
markers = cell(1);
full_block = 0;
for block = 1:Nblocks
%     Start one marker after the start marker (1) 
%     and stop two markers before (exclude 'Start Epoch' and 'S 1'):
%     range = start_marks(block)+1:stop_marks(block)-2; % 17.4.08
    range = start_marks(block)+1:stop_marks(block); % 17.4.08
    range = range(codes(range,1)=='S'); % Leave only stimuli in the range 28.10.08
    if range > 0
        full_block = full_block+1;
        markers{full_block} = [ times(range) str2num(codes(range,3:4)) ];
    end
end