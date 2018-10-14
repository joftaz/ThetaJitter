%% reloading data
fig_path = fileparts(mfilename('fullpath'));
load([fig_path, '/' 'FigA2.mat'])

%% recalculating phases
phase_hilbert = get_hilbert_phase(shiftdim(trials,2), 4.5, 8, dt*1000);
% phase_r = circ_r(phase_hilbert,[],[],3);
phase_std = circ_std(phase_hilbert,[],[],3);

%% plotting data 
figure;
% varplot(jitters,phase_r(100 <t & t<500,:)','std');
varplot(jitters,phase_std(100 <t & t<500,:)','std');
% legend(cellstr(num2str(t(1:100:400)', 'times=%.3g [ms]')))
% set(h, {'color'}, num2cell(winter(length(h)),2));
xlabel 'jitter [ms]'
ylabel 'phase coherence'
ylim([0,1])
yticks([0, .25, 0.5, .75 1])

grid on

%% save fig
savefig([fig_path '/' 'FigA2.fig'])
saveas(gcf, [fig_path '/' 'FigA2.png'])