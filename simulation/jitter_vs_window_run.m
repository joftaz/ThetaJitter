%% some numbers.
% all times are in [ms]
dt  = 2;
tmax = 1000;
tmin = -200;
fs = 1/dt;
len_sample = floor((tmax-tmin)*fs);
t = linspace(tmin, tmax, len_sample);
N2_widths = 50:50:401;
ratio_jitters = [0 0.05 0.3 0.55 0.8 1.05 1.3];
num_trails = 100;
freqs = logspace(log10(2), log10(60), 30);

tot_erp = zeros(length(N2_widths), length(ratio_jitters));
tot_orig = zeros(size(tot_erp));
tot_sub = zeros(size(tot_erp));
tot_diff = zeros(size(tot_erp));
    
%% run the script for different N2 widths
for ii_width = 1:length(N2_widths)
    tic
    N2_width = N2_widths(ii_width);
    jitters = ceil(N2_width.*ratio_jitters/4)*4;
    
    %% generating base wave
    n1 = N200Generator(fs, tmin, tmax, N2_width);
    n2 = circshift(n1, [1,-10*fs]);
    baseN2 = (n1-n2)*4;
   
    %% generating erps data
    trials = zeros(length(t), length(jitters), num_trails);
    for ii = 1:length(jitters)
        trials(:,ii,:) = N200matWithJitter(baseN2, num_trails, jitters(ii)*fs);
    end
    erps = squeeze(mean(trials,3));
    
    % plotting all erps
    figure;
    plot(t,baseN2,'k--')
    hold on
    plot(t,erps')
    xlabel time[ms]
    ylabel [Au]
    title(sprintf('ERPs for different jitters with original window size %d [ms]', N2_width));
    
    legend_str = cellstr(num2str(jitters', 'jitter=%-d[ms]'));
    legend_str_all = [{'base N2'} ; legend_str];
    legend(legend_str_all);

    hold off
        
    %% Subtracting ERPs
    sub_trials = zeros(size(trials));
    for ii = 1:length(jitters)
        for jj = 1:num_trails
            %         sub_trials(ii,,:) = bsxfun(@minus, trials(ii,:,:), erps(ii,:)');
            sub_trials(:,ii,jj) = squeeze(trials(:,ii,jj)) - erps(:,ii);
        end
    end
    
    %% spectral analysis
    originals_freq_power = zeros([length(jitters) length(freqs) length(t)]);
    subtrials_freq_power = originals_freq_power;
    total_freq_phase = zeros([length(jitters) length(freqs) length(t) num_trails]);
    erps_freq_power = getPowerSpectra(erps',dt, freqs); %freq-time-channel

    for ii = 1:length(jitters)
        [power,ph] = getPowerSpectra(squeeze(trials(:,ii,:))',dt, freqs);
        originals_freq_power(ii,:,:) = mean(power,3);
%         total_freq_phase(ii,:,:,:) = ph;
        [power,~] = getPowerSpectra(squeeze(sub_trials(:,ii,:))',dt, freqs);
        subtrials_freq_power(ii,:,:) = mean(power,3);    
    end
    diff_original_subtracted_trials = originals_freq_power - subtrials_freq_power;
            
    %% compare jitter size to sum of spectral information    
    tot_freq_sum = @(X) squeeze(sum(sum(X,3),2)); 
    
    tot_erp(ii_width, :) = squeeze(sum(sum(erps_freq_power,2),1));
    tot_orig(ii_width, :) = tot_freq_sum(originals_freq_power);
    tot_sub(ii_width, :) = tot_freq_sum(subtrials_freq_power);
    tot_diff(ii_width, :) = tot_freq_sum(diff_original_subtracted_trials);
    
    toc
end

%% normalize powers by the original mean power
base_factor = mean(tot_orig,2);
norm_tot = @(X)bsxfun(@rdivide, X, base_factor);
tot_erp_n = norm_tot(tot_erp);
tot_orig_n = norm_tot(tot_orig);
tot_sub_n = norm_tot(tot_sub);
tot_diff_n = norm_tot(tot_diff);

% plt_colors = {'b','g','r','c'};
figure
    
% H(1) = stdshade(tot_erp_n, 0.2, 'b', ratio_jitters, 3);
% H(2) = stdshade(tot_orig_n, 0.2, 'g', ratio_jitters, 3)
% H(3) = stdshade(tot_sub_n, 0.2, 'r', ratio_jitters, 3)
% H(4) = stdshade(tot_diff_n, 0.2, 'c', ratio_jitters, 3)

hold on
H(1) = shadedErrorBar(ratio_jitters, tot_erp_n, {@mean, @std}, {'-b', 'LineWidth', 1.5}, 1);
H(2) = shadedErrorBar(ratio_jitters, tot_orig_n, {@mean, @std}, {'-g', 'LineWidth', 1.5}, 1);
H(3) = shadedErrorBar(ratio_jitters, tot_sub_n, {@mean, @std}, {'-r', 'LineWidth', 1.5}, 1);
H(4) = shadedErrorBar(ratio_jitters, tot_diff_n, {@mean, @std}, {'-c', 'LineWidth', 1.5}, 1);

title 'total spectral power for different jitter sizes'
xlabel 'jitter fraction'
ylabel 'total spectral power [Au]'
strlegend = {'ERP', 'total', 'non-phased-locked', 'phase-locked'};
legend([H.mainLine], strlegend)
