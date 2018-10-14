function [power_original_b, power_sub_b, erp_b] = get_linear_regression_step( step_result, trials, condition_labels)
y = condition_labels';
power_original_b=squeeze(zeros(size(step_result.originals_power(1,:,:))));
power_sub_b=power_original_b;
erp_b = squeeze(zeros(size(trials(:,1,1))))';
for jj=1:size(power_original_b,2)
    x = squeeze(trials(jj,1,:));
    erp_b(jj) = linear_regression_slope(x,y);
    for ii=1:size(power_original_b,1)
        x = step_result.originals_power(:,ii,jj);
        power_original_b(ii,jj) = linear_regression_slope(x,y);
        x = step_result.subtrials_power(:,ii,jj);
        power_sub_b(ii,jj) = linear_regression_slope(x,y);
    end
end
