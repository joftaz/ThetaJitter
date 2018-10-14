%% Spectral analysis of FCz
addpath('..')

%% some numbers.
% all times are in [ms]
channels={'FCz','Fz','Pz'};
n_channels = length(channels);
n_segs = size(FCz,2);
n_points = size(FCz,1);
num_trails = size(trials,3);
trials = zeros(n_points, n_channels, n_segs);
trials(:,1,:) = FCz;
trials(:,2,:) = Fz;
trials(:,3,:) = Pz;

%normalize
trials = trials/max(trials(:));

%% plot just one trial 
base = squeeze( trials(:,1,1));

ERPfigure;
plot(t, base )
xlabel t[ms]
ylabel [Au]
title 'base trial with window of ';

%% generating erps data

erps = zeros(n_channels, length(t));
for ii = 1:n_channels
    erps(ii,:) = mean(trials(:,ii,:),3);
end

% plotting all erps
ERPfigure;
hold on
plot(t,-erps')
xlabel time[ms]
ylabel [Au]
hold off
title('ERPs for different channels');

legend_str = {'FCz', 'Fz', 'Pz'};
legend(legend_str);

%% Subtracting ERPs
sub_trials = zeros(size(trials));
for ii = 1:n_channels
    for jj = 1:n_segs
        %         sub_trials(ii,,:) = bsxfun(@minus, trials(ii,:,:), erps(ii,:)');
        sub_trials(:,ii,jj) = squeeze(trials(:,ii,jj)) - erps(ii,:)';
    end
end

%% plot graph of each ERP with its subtracted trials
ERPfigure;
for ii = 1:n_channels
    % plotting all erps
    subplot(ceil(n_channels/2),2,ii);
    %     figure
    
    imagesc(t, [-1, 1], squeeze(sub_trials(:,ii,:))');
    hold on
    plot(t, erps(ii,:), 'linewidth',2,'color','k');
    
    axis xy
    caxis([min(sub_trials(:)), max(sub_trials(:))])
    set(gca,'XTick',[]);
    ylabel [Au]
    title(sprintf('ERP and subtracted trials from %s', channels{ii}));
    hold off
end
xlabel time[ms]
set(gca,'xtickMode', 'auto')



%% spectral analysis
dt = SamplingInterval/1000;
addpath('..')
[base_power, freq, ~] = myCwt(t, base, dt);
originals_freq_power = zeros([n_channels size(base_power)]);
subtrials_freq_power = originals_freq_power;

erps_freq_power = myCwt(t,erps,dt); %freq-time-channel
erps_freq_power = shiftdim(erps_freq_power,2); %channel-freq-time

for ii = 1:n_channels
    originals_freq_power(ii,:,:) = squeeze(sum(myCwt(t,squeeze(trials(:,ii,:))',dt),3));
    subtrials_freq_power(ii,:,:) = squeeze(sum(myCwt(t,squeeze(sub_trials(:,ii,:))',dt),3));
end
originals_freq_power = originals_freq_power / n_segs;
subtrials_freq_power = subtrials_freq_power / n_segs;
diff_original_subtracted_trials = originals_freq_power - subtrials_freq_power;

%% helperCWTTimeFreqPlot
PlotType = 'image';
for ii = 1:n_channels
    
    h = ERPfigure;
    subplot(2,2,2)
    helperCWTTimeFreqPlot(squeeze(originals_freq_power(ii,:,:)), t, freq, PlotType, {'mean original trials','(total)'})
    Ca = caxis;
    subplot(2,2,1)
    helperCWTTimeFreqPlot(squeeze(erps_freq_power(ii,:,:)), t, freq, PlotType, 'ERP')
%     caxis(Ca)
    subplot(2,2,3)
    helperCWTTimeFreqPlot(squeeze(subtrials_freq_power(ii,:,:)), t, freq, PlotType, {'mean subtracted trails', '(non-phase-locked)'})
%     caxis(Ca)
    subplot(2,2,4)
    helperCWTTimeFreqPlot(squeeze(diff_original_subtracted_trials(ii,:,:)), t, freq, PlotType, {'mean diff original with subtracted','(phase-locked)'})
%     caxis(Ca)
    
    %title for the figure
    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 1,sprintf('\\bf %s [ms]', channels{ii}),'HorizontalAlignment' ,'center','VerticalAlignment', 'top');

%     saveas(h, sprintf('./graphs/MATLAB_cwtft/spectogram_with_jitter_%dms.jpg', n_channels(ii))); 
end

