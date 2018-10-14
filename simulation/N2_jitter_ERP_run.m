%% some numbers.
% all times are in [ms]
dt  = 0.1;
tmax = 1000;
tmin = -200;
fs = floor(1/dt);
len_sample = floor((tmax-tmin)*fs);
t = linspace(tmin, tmax, len_sample);
N2_width = 200;
jitters = 10:50:300;
num_trails = 100;

%% generating base wave
n1 = N200Generator(fs, tmin, tmax, N2_width);
% n2 = circshift(n1, [1,-10*fs]);
% baseN2 = (n1-n2)*4;
baseN2 = n1;

figure;
plot(t, baseN2 )
xlabel t[ms]
ylabel [Au]
title 'base N2 with window of 200ms, starts on 200ms tick';

%% generating erps data
erps = zeros(length(jitters), length(t));
trials = zeros(length(jitters), num_trails, length(t));
for ii = 1:length(jitters)
    trials(ii,:,:) = N200matWithJitter(baseN2, num_trails, jitters(ii)*fs);
    erps(ii,:) = mean(trials(ii,:,:));
end

% plotting all erps
figure;
plot(t,baseN2,'k--')
hold on
plot(t,erps')
xlabel time[ms]
ylabel [Au]
hold off
title(sprintf('ERPs for different jitters with original window size %d [ms]', N2_width));

legend_str = cellstr(num2str(jitters', 'jitter=%-d[ms]'));
legend_str_all = [{'base N2'} ; legend_str];
legend(legend_str_all);

%% plot graph of each ERP with its trials
figure;
for ii = 1:length(jitters)
    % plotting all erps
    subplot(ceil(length(jitters)/2),2,ii);
    %     figure
    
    imagesc(t, [-1, 1], squeeze(trials(ii,:,:)));
    hold on
    plot(t, erps(ii,:), 'linewidth',2,'color','k');
    plot(t, baseN2 , 'r--', 'linewidth',2)
    
    axis xy
    caxis([min(trials(:)), max(trials(:))])
    set(gca,'XTick',[]);
    ylabel [Au]
    title(sprintf('ERP and trials with jitter size %d [ms]', jitters(ii)));
    legend({'ERP', 'base'})
    hold off
end
xlabel time[ms]
set(gca,'xtickMode', 'auto')

%% Subtracting ERPs
sub_trials = zeros(size(trials));
sub_erps = zeros(size(erps));
for ii = 1:length(jitters)
    for jj = 1:num_trails
        %         sub_trials(ii,,:) = bsxfun(@minus, trials(ii,:,:), erps(ii,:)');
        sub_trials(ii, jj, :) = squeeze(trials(ii,jj,:))' - erps(ii,:);
    end
    sub_erps(ii,:) = mean(sub_trials(ii,:,:));
end

%% plot graph of each ERP with its subtracted trials
figure;
for ii = 1:length(jitters)
    % plotting all erps
    subplot(ceil(length(jitters)/2),2,ii);
    %     figure
    
    imagesc(t, [-1, 1], squeeze(sub_trials(ii,:,:)));
    hold on
    plot(t, erps(ii,:), 'linewidth',2,'color','k');
    plot(t, baseN2 , 'r--', 'linewidth',2)
    
    axis xy
    caxis([min(sub_trials(:)), max(sub_trials(:))])
    set(gca,'XTick',[]);
    ylabel [Au]
    title(sprintf('ERP and subtracted trials with jitter size %d [ms]', jitters(ii)));
    legend({'ERP', 'base'})
    hold off
end
xlabel time[ms]
set(gca,'xtickMode', 'auto')



%% spectral analysis
[base_power, freq, ~] = myCwt(t, baseN2, dt);
originals_freq_power = zeros([length(jitters) size(base_power)]);
subtrials_freq_power = originals_freq_power;

erps_freq_power = myCwt(t,erps,dt); %freq-time-channel
erps_freq_power = shiftdim(erps_freq_power,2); %channel-freq-time

for ii = 1:length(jitters)
    originals_freq_power(ii,:,:) = sum(myCwt(t,trials(ii,:,:),dt),3);
    subtrials_freq_power(ii,:,:) = sum(myCwt(t,sub_trials(ii,:,:),dt),3);
    
    %     for jj = 1:num_trails
    %          originals_freq_power(ii,:,:) = squeeze(originals_freq_power(ii,:,:)) + myCwt(t,trials(ii,jj,:),dt);
    %          subtrials_freq_power(ii,:,:) = squeeze(subtrials_freq_power(ii,:,:)) + myCwt(t,sub_trials(ii,jj,:),dt);
    %     end
end
originals_freq_power = originals_freq_power / num_trails;
subtrials_freq_power = subtrials_freq_power / num_trails;
diff_original_subtracted_trials = originals_freq_power - subtrials_freq_power;

%% helperCWTTimeFreqPlot
PlotType = 'contourf';
for ii = 1:length(jitters)
    % ii=4;
    h = figure;
    subplot(2,2,2)
    helperCWTTimeFreqPlot(squeeze(originals_freq_power(ii,:,:)), t, freq, PlotType, {'mean original trials','(total)'})
    Ca = caxis;
    subplot(2,2,1)
    helperCWTTimeFreqPlot(squeeze(erps_freq_power(ii,:,:)), t, freq, PlotType, 'ERP')
    caxis(Ca)
    subplot(2,2,3)
    helperCWTTimeFreqPlot(squeeze(subtrials_freq_power(ii,:,:)), t, freq, PlotType, {'mean subtracted trails', '(non-phase-locked)'})
    caxis(Ca)
    subplot(2,2,4)
    helperCWTTimeFreqPlot(squeeze(diff_original_subtracted_trials(ii,:,:)), t, freq, PlotType, {'mean diff original with subtracted','(phase-locked)'})
    caxis(Ca)
    
    %title for the figure
    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 1,sprintf('\\bf jitter = %d [ms]', jitters(ii)),'HorizontalAlignment' ,'center','VerticalAlignment', 'top');

    saveas(h, sprintf('./graphs/gaussian/spectogram_with_jitter_%dms.jpg', jitters(ii))); 
end

%% compare jitter size to sum of spectral information
tot_freq_sum = @(X) sum(sum(X,2),3);
tot_erp = tot_freq_sum(erps_freq_power);
tot_orig = tot_freq_sum(originals_freq_power);
tot_sub = tot_freq_sum(subtrials_freq_power);
tot_diff = tot_freq_sum(diff_original_subtracted_trials);

figure
plot(jitters, [tot_erp, tot_orig, tot_sub, tot_diff]');
title 'total spectral power for different jitter sizes'
xlabel 'jitter [ms]'
ylabel 'total spectral power [Au]'
legend({'ERP', 'total', 'non-phased-locked', 'phase-locked'})


