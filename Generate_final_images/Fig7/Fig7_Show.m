%% 
fig_path = fileparts(mfilename('fullpath'));
load([fig_path '/' 'Fig7.mat']);

%% plot compasses
subj = 16;
mask = t_min_max(1)<times & times<t_min_max(2);

[~,t_ind_subj] = max(mean(theta_phases_r(:,:,subj),2).*mask');
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
varplot(t,squeeze(theta_phases_r(u,:,subj)) )
xlabel Time
xunits ms %replace
axis square
ylabel 'Phase choherence'

freq_mean = sqrt(freq_max*freq_min);
jitter_estimate = 1/sqrt(kappa) * pi/2 / freq_mean / SamplingInterval * 1e6;

fprintf('jitter estimate is %.0f [ms] at t ~ %.0f [ms]\n', jitter_estimate , times(t_ind_subj))

%% save fig
fig_path = fileparts(mfilename('fullpath'));
savefig([fig_path '/' 'Fig7.fig'])
saveas(gcf, [fig_path '/' 'Fig7.png'])