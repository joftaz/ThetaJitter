function show_spectrum(amp, t, freqs, PlotType, title_str, show_colorbar, title_colorbar)

if ~exist('title_colorbar','var') || isempty(title_colorbar)
    title_colorbar = 'Power [dB]';
end

if ~exist('show_colorbar','var') || isempty(show_colorbar)
    show_colorbar = true;
end


if strncmpi(PlotType,'surf',1)
    surf(t,freqs,double(amp))%,'edgecolor','none');
    view(0,90);
    axis tight;
    shading interp;
%     colormap jet;
    
elseif strcmpi(PlotType,'contourf')
    contourf(t,freqs,amp);
    grid on; colormap(parula(128));
    
end

if show_colorbar
    h = colorbar;
    title(h,title_colorbar);
end

xlabel('Time [ms]');
ylabel('frequncy [Hz]');
if exist('title_str','var')
    title(title_str)
end

set(gca,'yscale','log')
set(gca,'YTick',round(logspace(log10(min(freqs)), log10(max(freqs)), 6)))
%     yticks(round(logspace(log10(min(freq)), log10(max(freq)), 5)))

end

