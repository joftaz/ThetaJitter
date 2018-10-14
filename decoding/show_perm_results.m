function show_perm_results(data, left_inds, right_inds, u, t, freqs, opt_freq, var_colors)

set_default('var_colors', []);

if left_inds<0
    left_inds = find(1:4 ~= -left_inds);
end
if right_inds<0
    right_inds = find(1:4 ~= -right_inds);  
end

if ndims(data) == 3
    trial_g_1 = squeeze(mean(data(u,left_inds, :),2));
    if right_inds ~= 0
        trial_g_2 = squeeze(mean(data(u,right_inds, :),2));
    end
else
    if nargin < 7 || isempty(opt_freq)
        trial_g_1 = squeeze(mean(data(:,u,left_inds, :),3));
        if right_inds ~= 0
            trial_g_2 = squeeze(mean(data(:,u,right_inds,:),3));
        end
        
    else
        trial_g_1 = squeeze(mean(mean(data(opt_freq,u,left_inds, :),3),1));
        if right_inds ~= 0
            trial_g_2 = squeeze(mean(mean(data(opt_freq,u,right_inds,:),3),1));
        end
    end
end

if right_inds == 0
    trial_g_2 = [];         
    trial_g = trial_g_1 - mean(trial_g_1(:));
else
    trial_g = trial_g_1 - trial_g_2;
end

p_thresh = 0.05;

if ndims(trial_g_1) == 3

%     [t_value_matrix, permutation_distribution_max, permutation_distribution_min] = permutest_max(trial_g_1, trial_g_2, true, 0.05, 10^4, false, inf);
    [clusters, p_values, t_sums, permutation_distribution ] = permutest(trial_g_1, trial_g_2, true, p_thresh, 10^4, false, inf);

    trial_m = mean(trial_g,3);
   
    figure;
    hold on
    contourf(t,freqs,trial_m,500,'LineStyle','none');
    colormap jet
    colorbar
    caxis([min(trial_m(:)),max(trial_m(:))])
    set(gca,'yscale','log')
    set(gca,'YTick',round(logspace(log10(min(freqs)), log10(max(freqs)), 6))) 
    
    for ii = 1:length(p_values)
        if p_values(ii) < p_thresh
            fprintf('Cluster %d: time points %d to %d, t-sum = %g, p-value = %g.\n', ...
            ii, clusters{ii}(1), clusters{ii}(end), t_sums(ii), p_values(ii));
            p = p_values(ii);
            inds = zeros(size(trial_m));
            inds(clusters{ii}) = 1;
            [C,h] = contour(t, freqs, inds,[p p],'k--');
            clabel(C,h,p);
        end
        
    end
    
else
    permutest_plot(trial_g_1, trial_g_2, true, 0.05, 10^4, false, inf, t, [], var_colors);
end

