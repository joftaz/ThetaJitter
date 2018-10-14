function erp_trials_plot(x, trials, plot_var)

if nargin<3
    plot_var = true;
end
erps = mean(trials,1);
hold on

imagesc(x, [min(erps), max(erps)]*1.2, trials)
if plot_var
    varplot(x, trials', 'linewidth',2,'color','k');
else
    plot(x, erps, 'linewidth',2,'color','k');
end

axis tight
axis xy

hold off
end

