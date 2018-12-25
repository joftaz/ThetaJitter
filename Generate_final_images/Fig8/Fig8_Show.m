%% 
fig_path = fileparts(mfilename('fullpath'));
load([fig_path '/' 'Fig8.mat']);

%% plot aligned and original images
figure;

colorbar_title = 'Power [db]';
subject_names = [{'original power', 'induced power', 'evoked power'},
                 {'aligned power', 'induced aligned power', 'evoked aligned power'}];
resampled = cat(4, squeeze(mean(resampled_power,3)), ...
               squeeze(mean(sub_power,3)), ...
               squeeze(mean(resampled_power,3))-median(sub_power,3));
aligned = cat(4,aligned_power, ...
               sub_aligned_power, ...
               aligned_power-sub_aligned_power);
datas = cat(3, resampled, aligned);   
overlap_data = [original_erp,aligned_erp]';

n_col = 3;
fig_title = '';
n_subjects = 6;
n_rows = ceil(n_subjects/n_col);
title_y = false;
col_titles = [];
marg_h = 0.1; 
marg_w = [0.1, 0.13];
gap = 0.02;
Ca = [-2, 2];
ha = reshape(tight_subplot(n_rows ,n_col,gap,marg_h,marg_w), n_col, n_rows)';

colors = cbrewer('div', 'RdBu', 64);
% colors = cbrewer('seq', 'OrRd', 64);
colors = flipud(colors); % puts red on top, blue at the bottom
colormap(colors);

for ii = 1:n_rows
       
    % spectograms
    for jj = 1:3

        data = squeeze(datas(:,u,ii, jj));
        args = {t,freqs,data };
%        imagesc(t,1:size(data,2),data)%,'edgecolor','none');
        
        h = ha(ii,jj);
        surf(h, args{:})%,'edgecolor','none');
        caxis(h, [-3 3]);
        % min(datas(:))
        view(h,0,90);
        axis(h,'tight');
        axis(h,'xy');
        shading(h,'interp'); 
        set(h,'YTick',[]);
        set(h,'yscale','log')
        set(h,'XTick',[]);
        caxis(h,Ca); % set the clim
        axis(h,'square')
        box(h,'off')
        title(h,subject_names{ii,jj})
    end

    % erp
    h=ha(ii,3);
    erp = overlap_data(ii,u);
    yyaxis(h,'right')
    mx = max(overlap_data(:));
    mn = min(overlap_data(:));
    plot(h,t, erp, 'linewidth',1,'color','k');
%     set(h,'YTick',[]);
    set(h,'YLim',[mn mx]);
    yyaxis(h,'left')
       
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
        set(ha(ii,1),'YMinorTick','off')
%         set(ha(ii,1),'YTickLabel',round(logspace(log10(min(freqs)), log10(max(freqs)), 5)))
    end

end
    
% plot-labels
axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.04, 0.5,'Frequncy [Hz]','VerticalAlignment' ,'middle','HorizontalAlignment', 'center', 'Rotation', 90);    
text(0.5, 0.04, 'Time [ms]','HorizontalAlignment' ,'center','VerticalAlignment', 'bottom');
    
% caxis([0,cmax])
ch = colorbar(ha(1));
ch.YTick = round(Ca);
ch.Position = [.92 0.27 0.02 0.5];
ch.Label.String = 'Power [dB]';
ch.Label.Rotation = -90;


%% save fig
fig_path = fileparts(mfilename('fullpath'));
savefig([fig_path '/' 'Fig8.fig'])
saveas(gcf, [fig_path '/' 'Fig8.png'])