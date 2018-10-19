function norm_power = norm_power_bl_range(power, bl_range)
    bl_values = mean(mean(power(:, bl_range, :),3),2);
    norm_power = 10 * log10(bsxfun(@rdivide,mean(power,3),bl_values));
end
