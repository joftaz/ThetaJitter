f = fopen('s701_221segments.dat','r')
data = fread(f,inf, 'float');
ndatapoints = 128;
nsegments = size(data,1) / ndatapoints;
segments = reshape(data, [ndatapoints nsegments]); 
size(segments)
% plot(segments(:,1)) %show first segment
% zerolines
% hold off
baseline = mean(segments(1:26,:));
mbaseline = baseline(ones(128,1),:);
segments_BC = segments - mbaseline;
time = -1*1000*26/256:1000/256: 101*1000/256
for i = 1:111
    l = plot(time, segments_BC(:,i));
    set(l,'tag',num2str(i))
    hold on
end
zerolines
