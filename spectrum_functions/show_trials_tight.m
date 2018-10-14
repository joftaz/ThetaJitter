function show_trials_tight(t, datas, n_col, fig_title, colorbar_title, overlap_data, subject_names)

if nargin < 6
    overlap_data = [];
end

n_subjects = length(datas);
n_rows = ceil(n_subjects/n_col);

if nargin < 7
    subject_names = 1:n_subjects;
end


if n_col > 1
    gap = 0.05;
else
    gap = 0;
end

ha = tight_subplot(n_rows ,n_col,gap,0.1,[0.1, 0.1]);

Ca = -1;
for ii = 1:n_subjects
    
    %     subplot(length(results),1,ii)
    axes(ha(ii));
    
    data = squeeze(datas{ii});
    
    imagesc(t,[-1 1],data)%,'edgecolor','none');
    
    if Ca == -1
        Ca = caxis;
    else
        caxis(Ca)
    end
%     caxis([min(datas(:)) max(datas(:))]);
    
    view(0,90);
    axis xy;
    axis tight;
    shading interp; %colormap(parula(128));
    set(gca,'YTick',[]);
    
    if n_col == 1
        ylabel(subject_names(ii));
    else
        title(subject_names(ii));
    end

    if overlap_data
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

%xlabel of whole fig
for ii=n_subjects-n_col+1:n_subjects
    axes(ha(ii));
    xlabel time[ms]
    set(gca,'XTickMode', 'auto')
end
  
%ylabel of whole fig
if n_col > 1
    for ii=1:n_col:n_subjects
        ylabel(ha(ii), 'Au')
        set(ha(ii), 'YTickmode', 'auto');
    end
end


%axes the whole figure
axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');

% hy
if n_col == 1
    text(0.04, 0.5,'Subject','VerticalAlignment' ,'middle','HorizontalAlignment', 'center', 'Rotation', 90);
end

%title for the figure
text(0.5, 1,sprintf('\\bf %s', fig_title),'HorizontalAlignment' ,'center','VerticalAlignment', 'top');

%  Trials with ERPs for different subjects for averaged over all conditions '\muV'
c = colorbar(ha(1));
% caxis([0,cmax])
title(c, colorbar_title);
c.Position = [.95 0.3 0.02 0.5];
end