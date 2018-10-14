function [] = beta_logistic_regression(results,  left_inds, right_inds, u, v, t, freqs, param, use_tsum, only_freqs, use_bin)
% param = original, sub, aligned, sub_aligned

if left_inds<0
    left_inds = find(1:4 ~= -left_inds);
end
if right_inds<0
    right_inds = find(1:4 ~= -right_inds);
end

if nargin < 9
    use_tsum = true;
end

if nargin < 10
    only_freqs = [];
end

if nargin < 11
    use_bin = true;
end

% bin_erps = zeros([size(results{1}.erp_b(u,:),1) length(results)]);

beta=zeros([size(squeeze(results{1}.power_raw(1,v,u,1))) length(results)]);
for sub_ind = 1:length(results)
    result = results{sub_ind};
    condition_positions = result.condition_positions;
    mask = sum(bsxfun(@(a,x)a==x,condition_positions',[left_inds, right_inds]),2)==1;
    switch (param)
        case 'original'
            data = result.power_raw;
        case 'sub'
            data = result.sub_power;
        case 'aligned'
            data = result.aligned_power;
        case 'sub_aligned'
            data = result.sub_aligned_power;
    end
    data = squeeze(data(1,v,u,mask));

%     bin_erps(:,sub_ind) = mean(result.erp_b(u,left_inds)>0,2);
    
    y = sum(bsxfun(@(a,x)a==x,condition_positions(mask)',left_inds),2);
    for jj=1:size(beta,2)
        for ii=1:size(beta,1)
            x = squeeze(data(ii,jj,:));
            if right_inds ~= 0
                beta(ii,jj,sub_ind) = linear_regression_slope(x,y);
%                 beta(ii,jj,sub_ind) =  mean(x(y==1)) - mean(x(y==0));
            else
                beta(ii,jj,sub_ind) =  mean(x(y==1));
            end
        end
    end
end
if right_inds ~= 0
    bin = beta;
    if use_bin 
        bin = bin>0;
    end
else
    bin = beta - mean(beta(:));    
end



if ~isempty(only_freqs)
    permutest_plot(squeeze(mean(bin(only_freqs,:,:),1)), bin_erps, true, 0.05, 10^4, false, inf, t);
%     permutest_plot(bin_erps, [], true, 0.05, 10^4, false, inf, t);
else
p_thresh = 0.05;
if use_tsum
    [clusters, p_values, t_sums, permutation_distribution ] = permutest(bin, 0.5, true, p_thresh, 10^4, false, inf);
else
    [p_value_mask, t_value_matrix, permutation_distribution_max, permutation_distribution_min] = permutest_max(bin, [], true, p_thresh, 10^4, false, inf);
end

bin_mean = squeeze(mean(bin,3));
figure;
hold on
contourf(t,freqs(v),bin_mean,500,'LineStyle','none');

colormap jet
colorbar
caxis([min(bin_mean(:)),max(bin_mean(:))])
set(gca,'yscale','log')
set(gca,'YTick',round(logspace(log10(min(freqs)), log10(max(freqs)), 6)))

if use_tsum
    for ii = 1:length(p_values)
        if p_values(ii) < p_thresh
            fprintf('Cluster %d: time points %d to %d, t-sum = %g, p-value = %g.\n', ...
                ii, clusters{ii}(1), clusters{ii}(end), t_sums(ii), p_values(ii));
            p = p_values(ii);
            inds = zeros(size(bin_mean));
            inds(clusters{ii}) = 1;
            [C,h] = contour(t, freqs(v), inds,[p p],'k--');
            clabel(C,h,p);
        end
        
    end
    
else
    
    p = p_thresh;
    [C,h] = contour(t, freqs(v), p_value_mask,[p p],'k--');
    clabel(C,h,p);
    
end


end
end