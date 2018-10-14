function [h] = show4images(t, freqs, img1, img2, img3, img4, title_str, plotType, isERPdb)

set_default('plotType', 'surf')
set_default('isERPdb', false)


subplot(2,2,2)
show_spectrum(img2, t, freqs, plotType,  'total', ~isERPdb)
set(gca,'XTick',[]);
xlabel ''
set(gca,'YTick',[]);
ylabel ''
Ca = caxis;
if isERPdb
    h = colorbar;
    title(h, 'Power [dB]');
    set(h, 'Position', [.85 0.3 0.03 0.5])
end

subplot(2,2,1)
if ~isERPdb
    show_spectrum(img1, t, freqs, plotType, 'ERP', ~isERPdb, 'Power')
else
    show_spectrum(img1, t, freqs, plotType, 'ERP', ~isERPdb)
    caxis(Ca)
end

xlabel ''
set(gca,'XTick',[]);
% caxis(Ca)

subplot(2,2,3)
show_spectrum(img3, t, freqs, plotType, 'induced', ~isERPdb)
caxis(Ca)

subplot(2,2,4)
show_spectrum(img4, t, freqs, plotType, 'evoked', ~isERPdb)
caxis(Ca)
set(gca,'YTick',[]);
ylabel ''
caxis(Ca)

if isERPdb
    for jj=1:4
      pos=get(subplot(2,2,jj), 'Position');
      set(subplot(2,2,jj), 'Position', [0.85*pos(1) 0.95*pos(2) 0.85*pos(3) pos(4)]);
    end
end

%title for the figure
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 1,sprintf('\\bf %s', title_str),'HorizontalAlignment' ,'center','VerticalAlignment', 'top');

end

