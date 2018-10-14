%% some numbers.
% all times are in [ms]

dt  = 2;
tmax = 1000;
tmin = -200;
fs = 1/dt;
len_sample = floor((tmax-tmin)*fs);
t = linspace(tmin, tmax, len_sample);
N2_width = 200;
jitters = [0 50:50:260];
num_trails = 100;

freqs = logspace(log10(2), log10(60), 30);

%% generating base wave

n1 = N200Generator(fs, tmin, tmax, N2_width);
n2 = circshift(n1, [1,-30*fs]);
baseN2 = (n1-n2)*2;

%% The spectrum of the original basic raw data

[p,pha] = getPowerSpectra(baseN2,dt, freqs);

%% generating jittered data

trials = zeros(length(t), length(jitters), num_trails);
for ii = 1:length(jitters)
    trials(:,ii,:) = N200matWithJitter(baseN2, num_trails, jitters(ii)*fs);
end


%% 
% calc erps data

erps = mean(trials,3)';

%% Subtracting ERPs

sub_trials = zeros(size(trials));
for ii = 1:length(jitters)
    for jj = 1:num_trails
        sub_trials(:,ii,jj) = squeeze(trials(:,ii,jj)) - erps(ii,:)';
    end
end

%% spectral analysis

originals_freq_power = zeros([length(jitters) length(freqs) length(t)]);
subtrials_freq_power = originals_freq_power;
total_freq_phase = zeros([length(jitters) length(freqs) length(t) num_trails]);
erps_freq_power = getPowerSpectra(erps,dt, freqs); %freq-time-channel
% erps_freq_power = shiftdim(erps_freq_power,2); %channel-freq-time

for ii = 1:length(jitters)
    [power,ph] = getPowerSpectra(squeeze(trials(:,ii,:))',dt, freqs);
    originals_freq_power(ii,:,:) = mean(power,3);
    total_freq_phase(ii,:,:,:) = ph;
    [power,~] = getPowerSpectra(squeeze(sub_trials(:,ii,:))',dt, freqs);
    subtrials_freq_power(ii,:,:) = mean(power,3);    
end
diff_original_subtracted_trials = originals_freq_power - subtrials_freq_power;


% %% plot graph of each ERP with its trials
% figure;
% for ii = 1:length(jitters)
%     % plotting all erps
%     subplot(ceil(length(jitters)/2),2,ii);
%     %     figure
%     
%     imagesc(t, [-1, 1], squeeze(trials(:,ii,:))');
%     hold on
%     plot(t, erps(ii,:), 'linewidth',2,'color','k');
%     plot(t, baseN2 , 'r--', 'linewidth',2)
%     
%     axis xy
%     caxis([min(trials(:)), max(trials(:))])
%     set(gca,'XTick',[]);
%     ylabel [Au]
%     colormap jet
%     title(sprintf('jitter size %d [ms]', jitters(ii)));
%     hold off
% end
% hl = legend({'ERP', 'base'});
% hl.Position = [0.84 0.76 hl.Position(3:4)];
% xlabel time[ms]
% set(gca, 'XTickMode', 'auto');
% 
% ax = subplot(ceil(length(jitters)/2),2,length(jitters)-1);
% xlabel time[ms]
% set(ax, 'XTickMode', 'auto');
% 
% title_subplots('ERP of different jitters')
%% Time Freq Plot
% close all
figure;
datas = zeros(size(originals_freq_power, 2), size(originals_freq_power, 3), size(originals_freq_power, 1), 3);
datas(:,:,:,1) = shiftdim(originals_freq_power,1);
datas(:,:,:,2) = shiftdim(subtrials_freq_power,1);
datas(:,:,:,3) = shiftdim(diff_original_subtracted_trials,1);

colorbar_title = 'Power';
subject_names = compose('j=%d', jitters);
title_y = true;
col_titles = {'Total power', 'Induced power', 'Evoked power','Trials'};
gap = 0.05;
marg_h = 0.1;
marg_w = 0.15;


n_col = 4;
n_rows = length(jitters);
n_subjects = n_col*n_rows;

ha = reshape(tight_subplot(n_rows ,n_col,gap,marg_h,marg_w), n_col, n_rows)';

% colors = cbrewer('div', 'RdBu', 64);
colors = cbrewer('seq', 'OrRd', 64);
% colors = flipud(colors); % puts red on top, blue at the bottom
        
for ii = 1:n_rows
       
    % spectograms
    for jj = 1:3

        data = squeeze(datas(:,:,ii, jj));
        args = {t,freqs,data };
%        imagesc(t,1:size(data,2),data)%,'edgecolor','none');
        
        h = ha(ii,jj);
        surf(h, args{:})%,'edgecolor','none');
        caxis(h, [min(datas(:)) max(datas(:))]);

        view(h,0,90);
        axis(h,'tight');
        axis(h,'xy');
        shading(h,'interp'); %colormap(parula(128));
        set(h,'YTick',[]);
        set(h,'yscale','log')
        set(h,'XTick',[]);
        colormap(h,colors);
    end

    % erp
    h=ha(ii,3);
    erp = erps(ii,:);
    yyaxis(h,'right')
    mx = max(erp);
    mn = min(erp);
    erp = ((erp - mn)/(mx-mn))*(size(data,2)-1) + 1;
    plot(h,t, erp, 'linewidth',1,'color','k');
    set(h,'YTick',[]);
    yyaxis(h,'left')
    
    %trials   
    h=ha(ii,4);
    imagesc(h,t, [-1, 1], squeeze(trials(:,ii,:))');
    set(h,'YTick',[]);
    hold(h,'on')
    yyaxis(h,'right');
    plot(h, t, erps(ii,:), 'linewidth',1,'color','k');
    plot(h, t, baseN2 , 'b-.', 'linewidth',1)
    
    axis(h,'xy')
    caxis(h,[min(trials(:)), max(trials(:))])
    set(h,'XTick',[]);
%     ylabel(h,'[Au]')
    hold(h,'off')
    colormap(parula)
end


%title of whole fig
for jj=1:length(col_titles)
    title(ha(1,jj), col_titles(jj));
end

%xlabel of whole fig
for jj=1:n_col
    set(ha(end,jj),'XTickMode', 'auto')
end

    
%ylabel of whole fig
if n_col > 1
    for ii=1:n_rows
        set(ha(ii,1),'YTick',round(logspace(log10(min(freqs)), log10(max(freqs)), 3)))
        if title_y
            ylabel(ha(ii,1), subject_names(ii));
        end
    end
end
    
% hy
axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
if n_col > 1
    text(0.04, 0.5,'Frequncy [Hz]','VerticalAlignment' ,'middle','HorizontalAlignment', 'center', 'Rotation', 90);    
else
    text(0.04, 0.5,'Subject','VerticalAlignment' ,'middle','HorizontalAlignment', 'center', 'Rotation', 90);    
end

text(0.5, 0, 'Time [ms]','HorizontalAlignment' ,'center','VerticalAlignment', 'bottom');
    

%  Trials with ERPs for different subjects for averaged over all conditions '\muV'
c = colorbar(ha(1));
% caxis([0,cmax])


title(c,colorbar_title);
c.Position = [.92 0.3 0.02 0.5];
c.Ticks = [min(c.Ticks), mean(c.Ticks), max(c.Ticks)];

%% Save figure
path = fileparts(mfilename('fullpath'));
savefig([path '/' 'Fig2.fig'])
saveas(gcf, [path '/' 'Fig2.png'])
