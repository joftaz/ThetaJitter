function showPolarTable(results, params, kind_norm, channel_name, freq, times)

phase_intervals = params.phase_intervals;
t = params.t(phase_intervals);
freqs = params.freqs;

channel = strcmp(channel_name,params.channel_names);

% [data] = [channel, freq, t, trials]
if strcmp(kind_norm,'original')
    data = results.original_phases;
else %sub
    data = results.subtrials_phases;
end

% figure
phases = squeeze(data(channel,find(freqs>freq,1), :,:));
% dif_phases = abs(diff(phases,1,1)*180/pi);
% dif_phases = mod(dif_phases, 360);
% 
% dif_times = diff(times)/2+times(1:end-1);
% varplot(dif_times, dif_phases)
% 
% figure
% varplot(times, phases)


ERPfigure
r = floor(sqrt(length(times)));
c = ceil(length(times)/r);
for ii = 1:length(times)
    subplot(r,c,ii)
    polarhistogram(phases(find(t<times(ii),1,'last'),:),10);
    title(sprintf('freq: %.2gHz time: %dms', freqs(find(freqs>freq,1)), times(ii)));
end