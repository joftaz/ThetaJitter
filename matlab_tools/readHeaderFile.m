function [datapoints,segments,nchannels,channels] = readHeaderFile(filename)
%READHEADERFILE return the generic Analyzer data file paramenters from the *.vhdr file.
%   [D,S,NC,C] = READHEADERFILE(F) returns the number of datapoints, segments and
%   channels and the channel names in the file F
% written by Shani Shalgi, many years ago
% modified by Shani 21/5/2012
% modified by Shani 9/6/2014 - textscan instead of textread
dotind = strfind(filename,'.');
%[headerFilename,~]= strtok(filename,'.');
inputHeaderFile = [filename(1:dotind(end)) 'vhdr'];
if exist(inputHeaderFile,'file') == 2 % Analyzer file
    fid=fopen(inputHeaderFile);
    inputHeaders = textscan(fid,'%s','delimiter','\n','whitespace','');
    inputHeaders=inputHeaders{1};
    fclose(fid);
    row = 7;
    if ~length(strfind(inputHeaders{row},'BINARY'))==1
        row = row+1;
    end
    
    if ~(length(strfind(inputHeaders{row},'BINARY'))==1 && length(strfind(inputHeaders{row+2},'MULTIPLEXED'))==1)
        error('Data file is not BINARY or not MULTIPLEXED.');
    end
    
    [~,numChannels] = strtok(inputHeaders{row+4},'=');
    nchannels = str2num(numChannels(2:length(numChannels)));
    
    [~,numDataPoints] = strtok(inputHeaders{row+10},'=');
    datapoints =  str2num(numDataPoints(2:length(numDataPoints)));
    
    [~,numSegments] = strtok(inputHeaders{row+5},'=');
    segments =  str2num(numSegments(2:length(numSegments)));
        
    if isempty(datapoints) % data is UNSEGMENTED
        datapoints=segments;
        segments=1;
    else
        segments = floor(segments/datapoints);
    end
    channels = cell(nchannels,1);
    j=row;
    while j<length(inputHeaders) 
        j=j+1;
        if strcmp(inputHeaders{j},'[Channel Infos]')
            c=0;
            for i=j+5:j+5+nchannels-1;
                c=c+1;
                [~,channel] = strtok(inputHeaders{i},'='); % Each entry: Ch<Channel number>=<Name>,<Reference channel name>,<Resolution in "Unit">,<Unit>
                [channel,~] = strtok(channel(2:length(channel)),',');
                channels{c} = channel;
            end
            j=length(inputHeaders)+2;
        end
    end
    
else
    error(['Unable to open header file ' inputHeaderFile]);
end

end
