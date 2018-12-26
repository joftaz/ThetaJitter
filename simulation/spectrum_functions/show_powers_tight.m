function [varargout] = show_powers_tight(t, freqs, datas, n_col, fig_title, colorbar_title, overlap_data, subject_names, title_y, col_titles, gap,  marg_h, marg_w)


n_subjects = size(datas,3);
n_rows = ceil(n_subjects/n_col);

set_default('title_y', n_col == 1);
set_default('subject_names', 1:n_subjects);
set_default('overlap_data', []);
set_default('col_titles', []);
set_default('marg_h', 0.05); 
set_default('marg_w', [0.1, 0.1]);

if n_col > 1
    set_default('gap', 0.05)
else
    set_default('gap', 0)
end

ha = tight_subplot(n_rows ,n_col,gap,marg_h,marg_w);


for ii = 1:n_subjects
    
    %     subplot(length(results),1,ii)
    axes(ha(ii));
    
    data = squeeze(datas(:,:,ii));
    
%     imagesc(t,1:size(data,2),data)%,'edgecolor','none');
    args = {t,freqs,data };

    surf(args{:})%,'edgecolor','none');
    caxis([min(datas(:)) max(datas(:))]);
    
    view(0,90);
    axis tight;
    axis xy;
    shading interp; %colormap(parula(128));
    set(gca,'YTick',[]);
    set(gca,'yscale','log')
    if ~title_y
        title(subject_names(ii));
    end
        
    hold on
    if ~isempty(overlap_data)
        erps = overlap_data(:,ii);
        yyaxis right
        mx = max(erps);
        mn = min(erps);
        erp = ((erps - mn)/(mx-mn))*(size(data,2)-1) + 1;
        plot(t, erp, 'linewidth',1,'color','k');
        set(gca,'YTick',[]);
        yyaxis left
    end
    set(gca,'XTick',[]);
    %     caxis([min(trials(:)), max(trials(:))])
end

%title of whole fig
for ii=1:length(col_titles)
    title(ha(ii), col_titles(ii));
end

%xlabel of whole fig
for ii=n_subjects-n_col+1:n_subjects
    set(ha(ii),'XTickMode', 'auto')
end

    
%ylabel of whole fig
if n_col > 1
    for ii=1:n_col:n_subjects
        set(ha(ii),'YTick',round(logspace(log10(min(freqs)), log10(max(freqs)), 6)))
        if title_y
            ylabel(ha(ii), subject_names((ii-1)/n_col+1));
        end
    end
%     if title_y
%         for ii=n_col:n_col:n_subjects
%                 yyaxis(ha(ii), 'right')
%                 set(ha(ii),'YTick',[]);    
%                 ylabel(ha(ii), subject_names(ii/n_col));
%         end
%     end

end

    
% hy
axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
if n_col > 1
    text(0.04, 0.5,'Frequncy [Hz]','VerticalAlignment' ,'middle','HorizontalAlignment', 'center', 'Rotation', 90);    
else
    text(0.04, 0.5,'Subject','VerticalAlignment' ,'middle','HorizontalAlignment', 'center', 'Rotation', 90);    
end

text(0.5, 0, 'Time [ms]','HorizontalAlignment' ,'center','VerticalAlignment', 'bottom');
    
%title for the figure
% axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 1,sprintf('\\bf %s', fig_title),'HorizontalAlignment' ,'center','VerticalAlignment', 'top');

%  Trials with ERPs for different subjects for averaged over all conditions '\muV'
c = colorbar(ha(1));
% caxis([0,cmax])
title(c,colorbar_title);
c.Position = [.95 0.3 0.02 0.5];

if nargout > 0
   varargout = {ha};
end
end