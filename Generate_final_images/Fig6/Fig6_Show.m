%% load data
fig_path = fileparts(mfilename('fullpath'));
load([fig_path '/' 'Fig6.mat']);

%% plot compasses
figure;
t0s = -200:50:550;
default_colors = get(groot,'factoryAxesColorOrder');
c1 = rgb('blue');
c2 = rgb('red');
c3 = rgb('neon green');

for ii = 1:length(t0s)
    subplot(4,8,ii*2-1)
    h1 = circ_plot2(theta_phases(:,find(times>t0s(ii),1)),'compass',{'-', 'Color', c1} ,true,'linewidth',2,'color',c3);
%     h1.ThetaTick = [];
    subplot(4,8,ii*2)
    h2 = circ_plot2(erp_theta_phases(:,find(times>t0s(ii),1)),'compass',{'-', 'Color', c2}, true,'linewidth',2,'color',c3);
%     h2.ThetaTick = [];
    h2.Position = h2.Position + [-0.015, 0, 0, 0];
% 
%     axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
%     text(h2.Position(1), h2.Position(2), sprintf('\\bf %d',t0s(ii)))
    ht = title(t0s(ii));
    ht.Position = ht.Position + [-1.2, 0, 0];
end


% b = circular mean of the phases in different times
% r = phases of the ERPs in different times

%% save fig
fig_path = fileparts(mfilename('fullpath'));
savefig([fig_path '/' 'Fig6.fig'])
saveas(gcf, [fig_path '/' 'Fig6.png'])