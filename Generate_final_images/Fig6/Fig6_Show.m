%% load data
fig_path = fileparts(mfilename('fullpath'));
load([fig_path '/' 'Fig6.mat']);

%% plot compasses
figure;
t0s = -200:50:550;
default_colors = get(groot,'factoryAxesColorOrder');
c1 = rgb('blue');
c2 = rgb('green');
c3 = rgb('red');

texts_pos = zeros(length(t0s),2);

for ii = 1:length(t0s)
    subplot(4,8,ii*2-1)
    h1 = circ_plot2(theta_phases(:,find(times>t0s(ii),1)),'polar',{'-', 'Color', c1} ,true,'linewidth',2,'color',c3);
    
    subplot(4,8,ii*2)
    h2 = circ_plot2(erp_theta_phases(:,find(times>t0s(ii),1)),'polar',{'-', 'Color', c2}, true,'linewidth',2,'color',c3);
    h2.Position = h2.Position + [-0.02, 0, 0, 0];
% 
    texts_pos(ii,:) = [mean([sum(h1.Position([1,3])) , h2.Position(1)]) , h1.Position(2) + h1.Position(4)];
    h1.ThetaTick = [];
%     ht = title(t0s(ii));
%     ht.Position = ht.Position + [-1.2, 0, 0];
%     if ii < length(t0s)
    if ii > 1
        h2.ThetaTick = [];
    else
        h2.ThetaTick = [0, pi/2, 3/2*pi];
        h2.ThetaTickLabels = {'0','$\pi/2$','$-\pi/2$'};
        h1.ThetaTick = [pi/2, pi, 3/2*pi];
        h1.ThetaTickLabels = {'$\pi/2$', '$\pm\pi$','$-\pi/2$'};
    end
    
end

axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
for ii = 1:length(t0s)
    text(texts_pos(ii,1),texts_pos(ii,2), sprintf('\\bf %d',t0s(ii)), 'HorizontalAlignment', 'center')
end 



% b = circular mean of the phases in different times
% r = phases of the ERPs in different times

%% save fig
fig_path = fileparts(mfilename('fullpath'));
savefig([fig_path '/' 'Fig6.fig'])
saveas(gcf, [fig_path '/' 'Fig6.png'])