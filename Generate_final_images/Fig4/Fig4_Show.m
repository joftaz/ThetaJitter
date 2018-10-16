%% Load data
load jitter_rep_total_power.mat

%% normalize powers by the original mean power
base_factor = tot_orig;
tot_erp_n = tot_erp./base_factor;
tot_orig_n = tot_orig./base_factor;
tot_sub_n = tot_sub./base_factor;
tot_diff_n = tot_diff./base_factor;

% plt_colors = {'b','g','r','c'};
figure
subplot(2,2,4)
    
% H(1) = stdshade(tot_erp_n, 0.2, 'b', ratio_jitters, 3);
hold on
% H(2) = stdshade(tot_orig_n, 0.2, 'g', ratio_jitters, 3);
% H(3) = stdshade(tot_sub_n, 0.2, 'r', ratio_jitters, 3);
% H(4) = stdshade(tot_diff_n, 0.2, 'c', ratio_jitters, 3);
ci_alpha = 0.95;
ci = @(data)(output(@()ttest(data,0,'alpha',1-ci_alpha),3));

hold on
% H(1) = shadedErrorBar(ratio_jitters, tot_erp_n, {@mean, @std}, {'-b', 'LineWidth', 1.5}, 1);
H(2) = shadedErrorBar(ratio_jitters, tot_orig_n, {@mean, ci, true}, {'-g', 'LineWidth', 1.5}, 1);
H(3) = shadedErrorBar(ratio_jitters, tot_sub_n, {@mean, ci, true}, {'-r', 'LineWidth', 1.5}, 1);
H(4) = shadedErrorBar(ratio_jitters, tot_diff_n, {@mean, ci, true}, {'-c', 'LineWidth', 1.5}, 1);

% title 'total spectral power for different 12 repetitions with 100 trials each'
% title 'total spectral power for different jitter sizes'
% xlabel 'jitter [ms]'
xlabel 'jitter ratio'
ylabel 'total spectral power [Au]'
% strlegend = {'ERP', 'total', 'non-phased-locked', 'phase-locked'};
strlegend = {'total', 'non-phase-locked', 'phase-locked'};
legend([H.mainLine], strlegend, 'Location', 'Best')

grid on

%% save fig
fig_path = fileparts(mfilename('fullpath'));
savefig([fig_path '/' 'Fig4.fig'])
saveas(gcf, [fig_path '/' 'Fig4.png'])