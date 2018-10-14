%% some numbers.
% all times are in [ms]
dt  = 0.1;
tmax = 1000;
tmin = -200;
fs = round(1/dt);
len_sample = floor((tmax-tmin)*fs);
t = linspace(tmin, tmax, len_sample);

noise.tscales = [150 250];
noise.amplitude = [0.5 1];
noise.jitters = [0 10:10:150] ;
noise.jitter = 0;
noise.randn = 0.1;

jitters = noise.jitters;
num_trails = 100;

%% generating erps data
erps = zeros(length(jitters), length(t));
trials = zeros(length(jitters), num_trails, length(t));
for ii = 1:length(jitters)
    noise.jitter = noise.jitters(ii) * fs;
    trials(ii,:,:) = N200matWithNoise(t, num_trails, noise);
    erps(ii,:) = mean(trials(ii,:,:));
end

%% plot graph of each ERP with all trials
baseN2 = squeeze(trials(1,1,:))';
figure;
plot(t, baseN2 )
xlabel t[ms]
ylabel [Au]
title 'base N2 with window of 200ms, starts on 200ms tick';

figure;
for ii = 1:length(jitters)
    % plotting all erps
    subplot(ceil(length(jitters)/2),2,ii)
    
    imagesc(t, [-1, 1], squeeze(trials(ii,:,:)));
    hold on
    plot(t, baseN2 , 'r--', 'linewidth',2)
    plot(t, erps(ii,:), 'linewidth',2,'color','k');
        
    axis xy
    caxis([min(trials(:)), max(trials(:))])
    set(gca,'XTick',[]);
    ylabel [Au]
    title(sprintf('ERP and trials jitter of %d', jitters(ii)));
    legend({'base', 'ERP'})
    hold off
    
end
xlabel time[ms]
set(gca,'xtickMode', 'auto')


%% Subtracting ERPs
sub_trials = zeros(size(trials));
for ii = 1:length(jitters)
    for jj = 1:num_trails
        %         sub_trials(ii,,:) = bsxfun(@minus, trials(ii,:,:), erps(ii,:)');
        sub_trials(ii, jj, :) = squeeze(trials(ii,jj,:))' - erps(ii,:);
    end
end

%% plot graph of each ERP with its subtracted trials
figure;
for ii = 1:length(jitters)
    % plotting all erps
    subplot(ceil(length(jitters)/2),2,ii)
    %     figure
    
    imagesc(t, [-1, 1], squeeze(sub_trials(ii,:,:)));
    hold on
    plot(t, baseN2 , 'r--', 'linewidth',2)
    plot(t, erps(ii,:), 'linewidth',2,'color','k');
    
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
[base_power, freq] = getPowerSpectra(baseN2, dt, freqs);
originals_freq_power = zeros([length(jitters) size(base_power)]);
subtrials_freq_power = originals_freq_power;

erps_freq_power = myCwt(t,erps,dt); %freq-time(-channel)
if(ndims(erps_freq_power))==2
    %for ploting competability
    erps_freq_power = reshape(erps_freq_power,[1 size(erps_freq_power)]);
else
    erps_freq_power = shiftdim(erps_freq_power,2); %channel-freq-time
end

for ii = 1:length(jitters)

    originals_freq_power(ii,:,:) = sum(getPowerSpectra(trials(ii,:,:),dt,freqs),3);
    subtrials_freq_power(ii,:,:) = sum(myCwt(sub_trials(ii,:,:),dt,freqs),3);
end
originals_freq_power = originals_freq_power / num_trails;
subtrials_freq_power = subtrials_freq_power / num_trails;
diff_original_subtracted_trials = originals_freq_power - subtrials_freq_power;

%% helperCWTTimeFreqPlot
PlotType = 'contourf';
for ii = 1:length(jitters)
    % ii=4;
    h = figure;
    subplot(2,2,1)
    helperCWTTimeFreqPlot(squeeze(erps_freq_power(ii,:,:)), t, freq, PlotType, 'ERP')
    subplot(2,2,2)
    helperCWTTimeFreqPlot(squeeze(originals_freq_power(ii,:,:)), t, freq, PlotType, {'mean original trials','(total)'})
    subplot(2,2,3)
    helperCWTTimeFreqPlot(squeeze(subtrials_freq_power(ii,:,:)), t, freq, PlotType, {'mean subtracted trails', '(non-phase-locked)'})
    subplot(2,2,4)
    helperCWTTimeFreqPlot(squeeze(diff_original_subtracted_trials(ii,:,:)), t, freq, PlotType, {'mean diff original with subtracted','(phase-locked)'})
    
    %title for the figure
    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 1,sprintf('\\bf jitter = %d', jitters(ii)),'HorizontalAlignment' ,'center','VerticalAlignment', 'top');

     saveas(h, sprintf('./graphs/with_noise/noise_spectogram_with_jitter_%dms.jpg', jitters(ii))); 
end

%% compare jitter size to sum of spectral information
figure
tot_freq_sum = @(X) sum(sum(X,2),3);
tot_erp = tot_freq_sum(erps_freq_power);
tot_orig = tot_freq_sum(originals_freq_power);
tot_sub = tot_freq_sum(subtrials_freq_power);
tot_diff = tot_freq_sum(diff_original_subtracted_trials);

plot(jitters, [tot_erp, tot_orig, tot_sub, tot_diff]');
title 'total spectral power for different jitter sizes'
xlabel 'jitter [ms]'
ylabel 'total spectral power [Au]'
legend({'ERP', 'total', 'non-phased-locked', 'phase-locked'})


