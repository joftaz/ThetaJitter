%% 
fig_path = fileparts(mfilename('fullpath'));
load([fig_path '/' 'Fig7.mat']);

%% plot compasses
subj = 8;
t_min_max = [-0,600];
mask = t_min_max(1)<times & times<t_min_max(2);

[~,t_ind_subj] = max(mean(theta_phases_r(:,:,subj),2).*mask');
% t_ind_subj = 100;
subj_theta_phases = cell2mat(cellfun(@(X) X(t_ind_subj,:),theta_phases_subjects(subj), 'UniformOutput' ,false));
% subj_theta_phases = theta_phases_subjects{subj};
[thetahat, kappa] = circ_vmpar(subj_theta_phases);
[p,a]=circ_vmpdf([], thetahat, kappa);
% 
% figure;
% histogram(subj_theta_phases,20)
% yyaxis right
% plot(a-pi,(1-p))
% title([int2str(times(t_ind_subj))])

figure
subplot(1,2,1)
polarhistogram(subj_theta_phases, 20,'Normalization','pdf',...
    'FaceAlpha',0, 'DisplayStyle','stairs');
pax = gca;
pax.ThetaAxisUnits = 'radians';
hold on
polarplot(a,p)

subplot(1,2,2)
%varplot(t,squeeze(mean(theta_phases_r(u,:,:),2)))
plot(t,squeeze(mean(theta_phases_r(u,:,subj),2)))
axis tight
xlabel Time
axis square
ylabel 'Phase choherence'

ylim([0 0.6])
xunits ms %replace

freq_mean = mean([freq_max,freq_min]);
jitter_estimate = sqrt(1-besseli(1,kappa)/besseli(0,kappa)) / freq_mean * 1e3;
% jitter_estimate = circ_var(subj_theta_phases,[],[],2) * pi/2/freq_mean * 1e3;

fprintf('jitter estimate is %.0f [ms] at t ~ %.0f [ms]\n', jitter_estimate , times(t_ind_subj))

%% save fig
fig_path = fileparts(mfilename('fullpath'));
savefig([fig_path '/' 'Fig7.fig'])
saveas(gcf, [fig_path '/' 'Fig7.png'])