function header=read_vhdr_commoninfos2(filename)

% read_vhdr_commoninfos2 (filename)  returns a structure with the values
% specified in the Common Infos file of a .vhdr file created by Analyzer 1
% 
%Tamar Regev, HCNL Oct 30 2016, 
% adapted from read_vhdr_commoninfos by Leon to Analyzer version 2

disp( ['Reading ' filename ' header'])
fid=fopen(filename,'r');
s=fgetl(fid);
% check version 
if ~strcmp(s, 'Brain Vision Data Exchange Header File Version 2.0')
    error('The file''s first line does not match a header file. Expecting ''Brain Vision Data Exchange Header File Version 1.0''')
end

%look for the title of the section
while ~strcmp(s,'[Common Infos]')
    s=fgetl(fid);
end

%% read the information
header.headerfilename = filename;
while 1
    s=fgetl(fid);
    
    if ~isempty(s) && ~strcmp(s(1),';')   %i.e. not a comment or empty line
        if strcmp(s(1),'[') %it's a new section
            break
        end
        %find the equal sign
        equal = strfind(s, '=');
        %check if the value is a number
        value = s(equal+1:end);
        if ~isempty(str2num(value))
            value = str2num(value);
        end
        header = setfield(header, s(1:equal-1), value);
    end
end


fclose(fid);
            




