function [clusters, p_values, t_sums, permutation_distribution ] = permutest_2dplot( trial_group_1, trial_group_2, ...
    dependent_samples, p_threshold, num_permutations, two_sided, num_clusters, use_tsum, t, freqs)

sig_cluster_threshold = 0.05;
if isscalar(trial_group_2)
    trial_group_2 = trial_group_2*ones(size(trial_group_1));
end

if ndims(trial_group_1) ~= 3
    error('petmutest_2dplot can visualize only 2DXsubjects data');
end

if nargin < 8 || isempty(use_tsum)
    use_tsum = true;
end

if nargin < 7 || isempty(num_clusters)
    num_clusters = inf;
end

if nargin < 6 || isempty(two_sided)
    two_sided = false;
end
if nargin < 5 || isempty(num_permutations)
    num_permutations = 10^4;
end
if nargin < 4 || isempty(p_threshold)
    p_threshold = 0.05;
end
if nargin < 3 || isempty(dependent_samples)
    dependent_samples = true;
end
if nargin < 2
    error('Not enough input arguments');
end

if use_tsum
    [clusters, p_values, t_sums, permutation_distribution ] = ...
        permutest(trial_group_1, trial_group_2, dependent_samples, p_threshold, num_permutations, two_sided, num_clusters);
else
    [p_value_mask, t_value_matrix, permutation_distribution_max, permutation_distribution_min] = ...
        permutest_max(trial_group_1, trial_group_2, dependent_samples, p_threshold, num_permutations, two_sided, num_clusters);
end

trial_mean = squeeze(mean(trial_group_1,3));
hold on
pcolor(t,freqs,trial_mean);
box off
shading interp
view(0,90);
colormap jet
axis tight
colorbar
caxis([min(trial_mean(:)),max(trial_mean(:))])
set(gca,'yscale','log')
set(gca,'YTick',round(logspace(log10(min(freqs)), log10(max(freqs)), 6)))
xlabel 'Time [ms]'
ylabel 'fequency [Hz]'

if use_tsum
    for ii = 1:length(p_values)
        if p_values(ii) < p_threshold
            fprintf('Cluster %d: time points %d to %d, t-sum = %g, p-value = %g.\n', ...
                ii, clusters{ii}(1), clusters{ii}(end), t_sums(ii), p_values(ii));
            p = p_values(ii);
            inds = zeros(size(trial_mean));
            inds(clusters{ii}) = 1;
            [C,h] = contour(t, freqs, inds,[p p],'k--');
            clabel(C,h,p);
            h.ContourZLevel = 0.01; % any number>0
%             h.ContourZLevel = max(trial_mean(:));
        end
        
    end
    
else
    
    p = p_threshold;
    [C,h] = contour(t, freqs, p_value_mask,[p p],'k--');
    clabel(C,h,p);
    
end

end

