%input: markers file (exported from Analyzer)
%output: trig matrix including one column of samples and one column of
%codes

function trig=readMarkers(markers)
'hi'
fid_markers = fopen(markers, 'rt');
tline_markers = fgetl(fid_markers);
tline_markers = fgetl(fid_markers);
tline_markers = fgetl(fid_markers);
i=0;
while (feof(fid_markers) == 0)
    i=i+1;
    tline_markers = fgetl(fid_markers);
    [token,line] = strtok(tline_markers,',');
    [code,line]=strtok(line,',');

    [samples,line]=strtok(line,',');
    trig(i,1)=str2num(samples);
    if code(3)=='  '
            code=code (4:end);
    else code=code(3:end);
    end 
    trig(i,2)=str2num(code);
end

