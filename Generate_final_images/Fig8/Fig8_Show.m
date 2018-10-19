%% 
fig_path = fileparts(mfilename('fullpath'));
load([fig_path '/' 'Fig8.mat']);

%% plot aligned and original images
figure;
% title_freq = sprintf('subject=%d, align woody', subj_ind);
title_freq = '';
show_powers_tight(t, freqs, cat(3, ...
                                squeeze(mean(resampled_power(:,u,:),3)), ...
                                squeeze(mean(sub_power(:,u,:),3)), ...
                                squeeze(mean(resampled_power(:,u,:),3))-median(sub_power(:,u,:),3), ...
                                aligned_power(:,u), ...
                                sub_aligned_power(:,u), ...
                                aligned_power(:,u)-sub_aligned_power(:,u)),...
3, title_freq, 'Power [db]', [], ...
{'original power', 'induced power', 'evoked power', 'aligned power', 'induced aligned power', 'evoked aligned power'}, ...
[], [], [], 0.1)

colors = cbrewer('div', 'RdBu', 64);
colors = flipud(colors); % puts red on top, blue at the bottom
colormap(colors);

subplots = get(gcf,'Children'); % Get each subplot in the figure
for i=1:length(subplots)% for each subplot
    if strcmp(subplots(i).Type,'axes') && ~all(subplots(i).Position == [0 0 1 1])
        caxis(subplots(i),[-3,3]); % set the clim
        axis(subplots(i),'square')
        box(subplots(i),'off')
    end
end

%% save fig
fig_path = fileparts(mfilename('fullpath'));
savefig([fig_path '/' 'Fig8.fig'])
saveas(gcf, [fig_path '/' 'Fig8.png'])