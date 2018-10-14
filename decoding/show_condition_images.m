function func = show_condition_images(t,freqs,u,data,condition_names)

if nargout > 0
    func = @(X)show_condition_images(t,freqs,u,X,condition_names);
else  
    ERPfigure;
    n = length(condition_names);
    for tt = 1:n
        subplot(n/2,2,tt)
        surf(t, freqs, data(:,u,tt));
        view(0,90);
        axis tight;
        %         shading flat
        shading interp; %colormap(parula(128));
        colormap jet
        xlabel t[ms]
        ylabel f[Hz]
        title(condition_names{tt})
        colorbar
         set(gca,'yscale','log')
        set(gca,'YTick',round(logspace(log10(min(freqs)), log10(max(freqs)), 5))) 
    end

end