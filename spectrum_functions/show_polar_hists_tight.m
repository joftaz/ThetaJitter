function show_polar_hists_tight(datas, n_col, fig_title, subject_names)

% datas in format of cell array with each cell contains list of phases


n_subjects = length(datas);
n_rows = ceil(n_subjects/n_col);

if nargin < 4
    subject_names = 1:n_subjects;
end


if n_col > 1
    gap = 0.01;
else
    gap = 0;
end

ha = tight_subplot(n_rows ,n_col,gap,0.1,[0.1, 0.1]);


for ii = 1:n_subjects
    
    %     subplot(length(results),1,ii)
    axes(ha(ii));
%     text(-1.35, 0, subject_names(ii));
    data = squeeze(datas{ii});
    polarhistogram(data, 10, 'Normalization','probability');
    pax = gca;
    pax.ThetaAxisUnits = 'radians';
    pax.RLim = [0, 0.2];
    pax.RTick = [];
    pax.ThetaTick = [];
%     pax.ThetaTick = linspace(0,2*pi,5);
    pax.GridLineStyle = ':';
    
    if n_col == 1
        ylabel(subject_names(ii));
    else
        text(pax, -.2, 0.5, num2str(subject_names(ii)), 'Units', 'normalized');
%         title(subject_names(ii)), %'VerticalAlignment', 'middle'
    end
        
end
% 
% %xlabel of whole fig
% for ii=n_subjects-n_col+1:n_subjects
%     axes(ha(ii));
%     xlabel time[ms]
%     set(gca,'XTickMode', 'auto')
% end
% 
% %ylabel of whole fig
% if n_col > 1
%     for ii=1:n_col:n_subjects
%         axes(ha(ii));       
%         set(gca,'YTick',round(logspace(log10(min(freqs)), log10(max(freqs)), 6)))
%     end
% end

    
% hy
axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.04, 0.5,'Subject','VerticalAlignment' ,'middle','HorizontalAlignment', 'center', 'Rotation', 90);

%title for the figure
% axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 1,sprintf('\\bf %s', fig_title),'HorizontalAlignment' ,'center','VerticalAlignment', 'top');

end