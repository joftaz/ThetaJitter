function [h] = displayTableSpectra(results, params, kind_norm, channel_name, PlotType)
%%
%kind_norm - trial, subject, all
%

times = params.window/params.srate;
u = times > - 200 & times < 1000;
t = times(u);
freq = params.freqs;

channel = strcmp(channel_name,params.channel_names);

switch kind_norm
    case 'trial'
        original_power = results.norm_trial_originals_power;
        subtrials_freq_power = results.norm_trial_subtrials_power;
%         diff_original_subtracted_freq_power = results.norm_trial_diff;
        erps_freq_power = results.erps_power;
    case 'subject'
        original_power = results.norm_subj_originals_power;
        subtrials_freq_power = results.norm_subj_subtrials_power;
%         diff_original_subtracted_freq_power = results.norm_subj_diff;
        erps_freq_power = results.erps_power;
    case 'all'
        original_power = results.norm_all_originals_power;
        subtrials_freq_power = results.norm_all_subtrials_power;
%         diff_original_subtracted_freq_power = results.originals_diff;
        erps_freq_power = results.norm_all_erps_power;
end

original_power = squeeze(original_power(channel,:,u));
erps_freq_power = squeeze(erps_freq_power(:,u,channel));
subtrials_freq_power = squeeze(subtrials_freq_power(channel,:,u));
% create diffs
diff_original_subtracted_freq_power = original_power - subtrials_freq_power;

h = ERPfigure;
subplot(2,2,2)
helperCWTTimeFreqPlot(original_power, t, freq, PlotType, {'mean original trials','(total)'})
Ca = caxis;
subplot(2,2,1)
helperCWTTimeFreqPlot(erps_freq_power, t, freq, PlotType, 'ERP')
% caxis(Ca)
subplot(2,2,3)
helperCWTTimeFreqPlot(subtrials_freq_power, t, freq, PlotType, {'mean subtracted trails', '(non-phase-locked)'})
caxis(Ca)
subplot(2,2,4)
helperCWTTimeFreqPlot(diff_original_subtracted_freq_power, t, freq, PlotType, {'mean diff original with subtracted','(phase-locked)'})
% caxis(Ca)


%title for the figure
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 1,sprintf('\\bf norm over %s of channel %s', kind_norm, channel_name),'HorizontalAlignment' ,'center','VerticalAlignment', 'top');

%     saveas(h, sprintf('./graphs/MATLAB_cwtft/spectogram_with_jitter_%dms.jpg', n_channels(ii))); 

end