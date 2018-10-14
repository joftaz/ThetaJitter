function chanlist=read_vhdr_channels(filename)

%read sections of vhdr files

fid=fopen(filename,'r');
s=[];
%read channel list
while ~strcmp(s,'[Channel Infos]')
    s=fgetl(fid);
end

while 1
    s=fgetl(fid);
    if ~strcmp(s(1),';') && ~isempty(s), break, end
end

if ~strcmp(s(1:2),'Ch') 
    error('Expecting ChX = ...')
else
%     [c, r] = strtok(s , '=')
% 	[c, r] = strtok(r(2:end) ,',');
%     chanlist{1} = c;
    count = 0;
    while strcmp(s(1:2),'Ch')
        count = count+1;
        [~, r] = strtok(s , '=');
		[c, ~] = strtok(r(2:end) ,',');
        chancell{count} = c;
         s=fgetl(fid);
         if isempty(s), break, end
    end
end
chanlist  = strvcat(chancell);

 disp(['Number of Channels: ' num2str(count)])
fclose(fid);
            




