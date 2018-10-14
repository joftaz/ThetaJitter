%% Recollecting data from BrainBonus2 (FCz)
load results_BrainBonus2.mat
recollect_data

%% 

plotType = 'surf';
subj = 8; %(Maybe 7?)

img1 = mean(total_powers(:,u,:,subj),3);
img2 = mean(sub_powers(:,u,:,subj),3);
img3 = img1-img2;
erp = squeeze(mean(total_erps(u,:,subj),2));

figure;
has = tight_subplot(1,3,[],[],[0.1, 0.1]);
axes(has(1))
show_spectrum(img1, t, freqs, plotType,  'Total Power', false)
% colormap(flipud(cbrewer('div','Spectral',128)))
colors = cbrewer('div', 'RdBu', 64);
% colors = cbrewer('seq', 'OrRd', 64);
colors = flipud(colors); % puts red on top, blue at the bottom
colormap(colors)
Ca = [-2, 2];
caxis(Ca)
% Ca = caxis;
% axis tight
axis square

axes(has(2));
show_spectrum(img2, t, freqs, plotType, 'Induced Power', false)
caxis(Ca)
set(gca,'YTick',[]);
ylabel ''
xlabel ''
axis square

axes(has(3));
show_spectrum(img3, t, freqs, plotType, 'Evoked Power', false)
set(gca,'YTick',[]);
ylabel ''
xlabel ''
caxis(Ca)
axis square

ch = colorbar;
ch.YTick = round(Ca);
ch.Position = [.92 0.33 0.02 0.33];
ch.Label.String = 'Power [dB]';
ch.Label.Rotation = -90;

axes(has(3));
hold on

yyaxis right
mx = max(erp);
mn = min(erp);
erp = ((erp - mn)/(mx-mn))*(size(img3,2)-1) + 1;
plot(t, erp, 'linewidth',2,'color','k');
set(gca,'YTick',[]);
yyaxis left


% %title for the figure
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% text(0.5, 1,sprintf('\\bf %d', subj),'HorizontalAlignment' ,'center','VerticalAlignment', 'top');

%% save fig
fig_path = fileparts(mfilename('fullpath'));
savefig([fig_path '/' 'Fig5.fig'])
saveas(gcf, [fig_path '/' 'Fig5.png'])
