function [clusters, p_values, t_sums, permutation_distribution ] = permutest_plot( trial_group_1, trial_group_2, ...
dependent_samples, p_threshold, num_permutations, two_sided, num_clusters, t, disp_results, var_colors)

set_default('disp_results', true)
set_default('var_colors', [])

sig_cluster_threshold = 0.05;
if isempty(trial_group_2)
    trial_group_2 = 0.5*ones(size(trial_group_1));
end
if isscalar(trial_group_2)
    trial_group_2 = trial_group_2*ones(size(trial_group_1));
end

if ~ismatrix(trial_group_1)
    error('petmutest_plot can visualize only 2D data');
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

[clusters, p_values, t_sums, permutation_distribution ] = permutest( trial_group_1, trial_group_2, ...
dependent_samples, p_threshold, num_permutations, two_sided, num_clusters );
 
hold on
if isempty(var_colors)    
    varplot(t, trial_group_1)
else
    varplot(t, trial_group_1, 'color', var_colors{1});
end
if ~isempty(trial_group_2)
    if isempty(var_colors)    
        varplot(t, trial_group_2)
    else
        varplot(t, trial_group_2, 'color', var_colors{2});  
    end
end

    
if ~isempty(clusters)
   
    if dependent_samples
        if two_sided
            title('Two-sided permutation test for dependent samples');
        else
            title('One-sided permutation test for dependent samples');
        end
    else
        if two_sided
            title('Two-sided permutation test for independent samples');
        else
            title('One-sided permutation test for independent samples');
        end
    end

    m1 = mean(trial_group_1,2);
    m2 = mean(trial_group_2,2);
    for c = 1:length(clusters)    
        if disp_results    
            fprintf('Cluster %d: time points %d to %d, t-sum = %g, p-value = %g.\n', ...
                    c, clusters{c}(1), clusters{c}(end), t_sums(c), p_values(c));
        end
        sig_clusters = find(p_values < sig_cluster_threshold);
        nonsig_clusters = find(p_values >= sig_cluster_threshold);
        for ii = 1:length(sig_clusters)
            m1clust = m1(clusters{sig_clusters(ii)});
            m2clust = m2(clusters{sig_clusters(ii)});
            patch(t([clusters{sig_clusters(ii)} clusters{sig_clusters(ii)}(end:-1:1)]),[m1clust' m2clust(end:-1:1)'],ii,'facealpha',0.5);
        end
        for ii = 1:length(nonsig_clusters)
            m1clust = m1(clusters{nonsig_clusters(ii)});
            m2clust = m2(clusters{nonsig_clusters(ii)});
            patch(t([clusters{nonsig_clusters(ii)} clusters{nonsig_clusters(ii)}(end:-1:1)]),[m1clust' m2clust(end:-1:1)'],length(sig_clusters)+ii,'facealpha',0);
        end
    end
else
    if disp_results    
        fprintf('No significant clusters found.\n');
    end
end

end
