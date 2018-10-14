function [power] = align_power_by_shift(power, shift)

n_channels = size(power,1);

for ii = 1:n_channels
    for jj=1:size(power,2)
        for kk = 1:length(shift)           
            power(ii,jj,:,kk) = circshift(power(ii,jj,:,kk), shift(kk));
        end
    end
end