fig_path = fileparts(mfilename('fullpath'));

load([fig_path, '/' 'window_rep_total_power.mat'])

%% normalize powers by the original mean power
base_factor = tot_orig;
tot_erp_n = tot_erp./base_factor;
tot_orig_n = tot_orig./base_factor;
tot_sub_n = tot_sub./base_factor;
tot_diff_n = tot_diff./base_factor;

clear H

figure
subplot(2,2,4)

% plt_colors = {'b','g','r','c'};
hold on

% H(1) = stdshade(tot_erp_n, 0.2, 'b', ratio_windows, 3);
% H(2) = stdshade(tot_orig_n, 0.2, 'g', ratio_windows, 3);
% H(3) = stdshade(tot_sub_n, 0.2, 'r', ratio_windows, 3);
% H(4) = stdshade(tot_diff_n, 0.2, 'c', ratio_windows, 3);
ci_alpha = 0.95;
ci = @(data)(output(@()ttest(data,0,'alpha',1-ci_alpha),3));

colors = cbrewer('qual', 'Set1', 3);

% H(1) = shadedErrorBar(ratio_jitters, tot_erp_n, {@mean, @std}, {'-b', 'LineWidth', 1.5}, 1);
H(2) = shadedErrorBar(ratio_windows*100, tot_orig_n, {@mean, ci, true}, {'-', 'Color',colors(1,:),'LineWidth', 1.5}, 1);
H(3) = shadedErrorBar(ratio_windows*100, tot_sub_n, {@mean, ci, true}, {'-', 'Color',colors(2,:), 'LineWidth', 1.5}, 1);
H(4) = shadedErrorBar(ratio_windows*100, tot_diff_n, {@mean, ci, true}, {'-', 'Color',colors(3 ,:), 'LineWidth', 1.5}, 1);

% H(1) = shadedErrorBar(jitters, tot_erp_n, {@mean, std}, {'-b', 'LineWidth', 1.5}, 1);
% H(2) = shadedErrorBar(ratio_windows*100, tot_orig_n, {@mean, ci, true}, {'-g', 'LineWidth', 1.5}, 1);
% H(3) = shadedErrorBar(ratio_windows*100, tot_sub_n, {@mean, ci, true}, {'-r', 'LineWidth', 1.5}, 1);
% H(4) = shadedErrorBar(ratio_windows*100, tot_diff_n, {@mean, ci, true}, {'-c', 'LineWidth', 1.5}, 1);

% title 'total spectral power for different 12 repetitions with 100 trials each'
% title 'total spectral power for different window variations'

xlabel 'waveform length ratio'
xtickformat('%.2g\\\%')
ylabel 'total spectral power [Au]'
% strlegend = {'ERP', 'total', 'non-phased-locked', 'phase-locked'};
strlegend = {'total', 'non-time-locked', 'time-locked'};
% legend([H.mainLine], strlegend, 'Location', 'BestOutside')

grid on

%% save fig
savefig([fig_path '/' 'FigA1.fig'])
saveas(gcf, [fig_path '/' 'FigA1.png'])