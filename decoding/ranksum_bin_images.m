%% ranksum of the bin images:
tic
control = 0*ones(1,length(subjects));
original_r = zeros(size(original_beta_mean));
sub_r = original_r;

for kk=1:max(condition_positions)
    for ii=1:size(original_beta,1)
        for jj=1:size(original_beta,2)
            original_r(ii,jj,kk) = ranksum(squeeze(original_beta(ii,jj,kk,:)),control, 'tail','right');
            sub_r(ii,jj,kk) = ranksum(squeeze(sub_beta(ii,jj,kk,:)),control, 'tail','right');
        end
    end
end

erp_r = zeros(size(erp_beta));
% control = 0.5*ones(1,size(erp_beta_mean,1));
for kk=1:max(condition_positions)
    for ii=1:size(erp_beta,1)
        erp_r(ii,kk) = ranksum(squeeze(erp_beta(ii,kk,:)),control, 'tail','right');
    end
end

toc