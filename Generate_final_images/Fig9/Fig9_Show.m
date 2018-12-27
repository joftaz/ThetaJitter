%% 
% fig_path = fileparts(mfilename('fullpath'));
load([fig_path '/' 'Fig9.mat']);

%% colors
colors = cbrewer('qual','Set1');
colors2 = {colors(1,:),colors(2,:)};
%% inds 
inds_right = [1,3];
inds_left= [2,4];
%% ERP
subplot(2,2,1)
show_perm_results(total_erps-mean(total_erps(bl_range,:,:)),inds_left,inds_right,u,t,freqs,[],colors2,false)

axis square
axis tight
% xlabel 'Time [ms]'
ylabel '$\mu V$'
title 'ERP'
% Cluster 1: t(131)=308 t(184)=515, t-sum = 149.259, p-value = 0.00059994
%% Theta
freq_inds = 4.5<freqs & freqs<8; % freqs(11)=6.4622Hz.
subplot(2,2,2)
show_perm_results(squeeze(total_powers(:,:,:,:)),inds_left,inds_right,u,t,freqs,freq_inds,colors2,true)

axis square
axis tight
% xlabel 'Time [ms]'
ylabel 'dB'
title 'Theta Power'


%% power
subplot(2,2,3)
show_perm_results(squeeze(total_powers(:,:,:,:)),inds_left,inds_right,u,t,freqs,[],[],true)
axis square
axis tight
xlabel 'Time [ms]'
ylabel 'frequncy [Hz]'
set(gca,'YMinorTick','off')
title 'Total Power'

ch = colorbar;
Ca = [-1.0 1.0];
caxis(Ca); 
ch.YTick = Ca;
ch.Position = [.44 0.10 0.02 0.35];
ch.Label.String = 'Power [dB]';
ch.Label.Rotation = -90;

%% R statistic
subplot(2,2,4)
show_perm_results( squeeze(theta_phases_r(:,:,:)),inds_right,inds_left,u,t,freqs,[],colors2,false,1e5)

axis square
axis tight
xlabel 'Time [ms]'
ylabel 'jitter [rad]'

title 'Inter Trial Phase Coherence'

%% save fig
fig_path = fileparts(mfilename('fullpath'));
savefig([fig_path '/' 'Fig9.fig'])
saveas(gcf, [fig_path '/' 'Fig9.png'])