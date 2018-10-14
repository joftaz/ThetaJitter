function markerList = readVMRKfile(filename)
%READVMRKFILE return the markers from the *.vmrk file.
% INPUT:
%   - filename: marker filename *.vmrk
%   - segmented
% OUTPUT:
%   - markerList - structure containing codeType, codeStr, ttime, howMany - corresponding to the <Type>,<Description>,<Position in data points>,
% <Size in data points> information in the marker file
%
% written by Shani Shalgi 21/5/2012

dotind = strfind(filename,'.');
filename = [filename(1:dotind(end)) 'vmrk'];
%[filename,~]= strtok(filename,'.');
%filename=[filename '.vmrk'] 

if exist(filename,'file') == 2 % File exists
    
    fid=fopen(filename);
    inputMarkers = textscan(fid, 'Mk%s%s%d%d%*[^\n]', 'headerlines',14,'delimiter',',');
    fclose(fid);
    markerList.codeType=cellfun(@getType,inputMarkers{1}, 'UniformOutput',false);
    markerList.codeStr=inputMarkers{2};
    markerList.ttime=inputMarkers{3};
    markerList.howMany=inputMarkers{4};
    markerList.stimInd=isStim(markerList.codeType);
    markerList.artInd=isArtifact(markerList.codeType);
    
    % sanity check 
    l1=length(markerList.codeType);
    lens= [length(markerList.codeStr) length(markerList.ttime) length(markerList.howMany) length(markerList.stimInd) length(markerList.artInd)];
    if any(lens-l1)
        error('Bad Marker file!');
    end
    
else
    error('File does not exist');
end
end

function str=getType(str)
[~,str]=strtok(str,'=');
str=str(2:end);
end

function stimBool=isStim(str)
  stimBool=strcmp(str,'Stimulus');
end

function artBool=isArtifact(str)
  artBool=strcmp(str,'Bad Interval');
end