%% retreive the data
load jitter_and_noise.mat
diff_original_subtracted_trials = originals_freq_power - subtrials_freq_power;

%% Time Freq Plot

close all
figure;
datas = zeros(size(originals_freq_power, 2), size(originals_freq_power, 3), size(originals_freq_power, 1),3);
datas(:,:,:,1) = shiftdim(originals_freq_power,1);
datas(:,:,:,2) = shiftdim(subtrials_freq_power,1);
datas(:,:,:,3) = shiftdim(diff_original_subtracted_trials,1);

colorbar_title = 'Power [dB]';
subject_names = compose('j=%d', jitters);
title_y = true;
col_titles = {'Total power', 'Induced power', 'Evoked power'};
gap = 0.05;
marg_h = 0.1;
marg_w = 0.15;


n_col = 3;
n_rows = length(jitters);
n_subjects = n_col*n_rows;

ha = reshape(tight_subplot(n_rows ,n_col,gap,marg_h,marg_w), n_col, n_rows)';

colors = cbrewer('div', 'RdBu', 64);
% colors = cbrewer('seq', 'OrRd', 64);
colors = flipud(colors); % puts red on top, blue at the bottom


for ii = 1:n_rows
       
    % spectograms
    for jj = 1:3

        data = squeeze(datas(:,u,ii, jj));
        args = {t(u),freqs,data };
%        imagesc(t,1:size(data,2),data)%,'edgecolor','none');
        
        h = ha(ii,jj);
        surf(h, args{:})%,'edgecolor','none');
        caxis(h, [-3 3]);
        % min(datas(:))
        view(h,0,90);
        axis(h,'tight');
        axis(h,'xy');
        shading(h,'interp'); 
        colormap(parula(128));
        set(h,'YTick',[]);
        set(h,'yscale','log')
        set(h,'XTick',[]);
        colormap(h,colors);
    end

    % erp
    h=ha(ii,3);
    erp = erps(ii,u);
    yyaxis(h,'right')
    mx = max(erp);
    mn = min(erp);
    erp = ((erp - mn)/(mx-mn))*(size(data,2)-1) + 1;
    plot(h,t(u), erp, 'linewidth',1,'color','k');
    set(h,'YTick',[]);
    yyaxis(h,'left')
    
    %trials   
%     h=ha(ii,4);
%     imagesc(h,t(u), [-1, 1], squeeze(trials(ii,:,u)));
%     set(h,'YTick',[]);
%     hold(h,'on')
%     yyaxis(h,'right');
%     plot(h, t(u), erp/max(erp), 'linewidth',1,'color','k');
% %    plot(h, t, baseN2 , 'b-.', 'linewidth',1)
%     
%     axis(h,'xy')
%     caxis(h,[min(trials(:)), max(trials(:))])
%     set(h,'XTick',[]);
% %     ylabel(h,'[Au]')
%     colormap(h,'jet')
%     hold(h,'off')
end


%title of whole fig
for jj=1:length(col_titles)
    title(ha(1,jj), col_titles(jj));
end

%xlabel of whole fig
for jj=1:n_col
    set(ha(end,jj),'XTickMode', 'auto')
end

    
%ylabel of whole fig
if n_col > 1
    for ii=1:n_rows
        set(ha(ii,1),'YTick',round(logspace(log10(min(freqs)), log10(max(freqs)), 6)))
        if title_y
            ylabel(ha(ii,1), subject_names(ii));
        end
    end

end
    
% hy
axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
if n_col > 1
    text(0.04, 0.5,'Frequncy [Hz]','VerticalAlignment' ,'middle','HorizontalAlignment', 'center', 'Rotation', 90);    
else
    text(0.04, 0.5,'Subject','VerticalAlignment' ,'middle','HorizontalAlignment', 'center', 'Rotation', 90);    
end

text(0.5, 0, 'Time [ms]','HorizontalAlignment' ,'center','VerticalAlignment', 'bottom');
    

%  Trials with ERPs for different subjects for averaged over all conditions '\muV'
c = colorbar(ha(1));
% caxis([0,cmax])
c.Ticks = [min(c.Ticks), mean(c.Ticks), max(c.Ticks)];
title(c,colorbar_title);
c.Position = [.92 0.3 0.02 0.5];
%% 
fig_path = fileparts(mfilename('fullpath'));
savefig([fig_path '/' 'Fig3.fig'])
saveas(gcf, [fig_path '/' 'Fig3.png'])