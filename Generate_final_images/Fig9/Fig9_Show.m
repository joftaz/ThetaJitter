%% 
fig_path = fileparts(mfilename('fullpath'));
load([fig_path '/' 'Fig9.mat']);

%% inds 
inds_right = [1,3];
inds_left= [2,4];
%% ERP
subplot(2,2,1)
show_perm_results(total_erps-mean(total_erps(bl_range,:,:)),inds_left,inds_right,u,t,freqs,[],[],false)

axis square
axis tight
% xlabel 'Time [ms]'
ylabel '$\mu V$'
title 'ERP'
% Cluster 1: t(131)=308 t(184)=515, t-sum = 149.259, p-value = 0.00059994
%% Theta
freq_inds = 4.5<freqs & freqs<8; % freqs(11)=6.4622Hz.
subplot(2,2,2)
show_perm_results(squeeze(total_powers(:,:,:,:)),inds_left,inds_right,u,t,freqs,freq_inds,[],true)

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

colorbar 'off'
title 'Spectrum Power'

%% R statistic
subplot(2,2,4)
show_perm_results( squeeze(theta_phases_r(:,:,:)),inds_left,inds_right,u,t,freqs,[],[],true)

axis square
axis tight
xlabel 'Time [ms]'
ylabel 'jitter [rad]'

title 'Mean Phase Coherence'

%% save fig
fig_path = fileparts(mfilename('fullpath'));
savefig([fig_path '/' 'Fig9.fig'])
saveas(gcf, [fig_path '/' 'Fig9.png'])