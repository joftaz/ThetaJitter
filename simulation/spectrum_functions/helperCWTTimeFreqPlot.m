function helperCWTTimeFreqPlot(amp,time,freq,PlotType,varargin)
%   This function helperCWTTimeFreqPlot is only in support of
%   CWTTimeFrequencyExample and PhysiologicSignalAnalysisExample. 
%   It may change in a future release.

params = parseinputs(varargin{:});
% amp = amp - mean(amp(:));

    if strncmpi(PlotType,'surf',1)
        args = {time,freq,double(amp)};
        surf(args{:})%,'edgecolor','none');
        view(0,90);
        axis tight;
        shading interp; 
      
        
        h = colorbar;
        title(h,'Power [dB]');
            if isempty(params.xlab) && isempty(params.ylab)
                xlabel('Time'); ylabel('Hz');
            else
             xlabel(params.xlab); ylabel(params.ylab);
            end
    
            
    elseif strcmpi(PlotType,'contour')
        contour(time,freq,amp);
        grid on; colormap(parula(128)); 
        h = colorbar;
        title(h,'Power [dB]');
            if isempty(params.xlab) && isempty(params.ylab)
                xlabel('Time'); ylabel('Hz');
            else
             xlabel(params.xlab); ylabel(params.ylab);
            end
            
    elseif strcmpi(PlotType,'contourf')
        contourf(time,freq,amp);    
        grid on; colormap(parula(128)); 
        h = colorbar;
        title(h,'Power [dB]');
            if isempty(params.xlab) && isempty(params.ylab)
                xlabel('Time'); ylabel('Hz');
            else
             xlabel(params.xlab); ylabel(params.ylab);
            end
            
    elseif strncmpi(PlotType,'image',1)
        imagesc(time,freq,amp);
%         colormap(parula(128)); 
        
        axis xy
        AX = gca;
        h = colorbar;
        title(h,'Power [dB]');
            if isempty(params.xlab) && isempty(params.ylab)
                xlabel('Time'); ylabel('Hz');
            else
                xlabel(params.xlab); ylabel(params.ylab);
            end
    end
    
    if ~isempty(params.PlotTitle)
        title(params.PlotTitle);
    end
    
    set(gca,'yscale','log')
%     set(gca,'YLim',[0 4])
    set(gca,'YTick',round(logspace(log10(min(freq)), log10(max(freq)), 6))) 

%     yticks(round(logspace(log10(min(freq)), log10(max(freq)), 5))) 
        
    
    
    %----------------------------------------------------------------
    function params = parseinputs(varargin)
        
        params.PlotTitle = [];
        params.xlab = [];
        params.ylab = [];
        params.threshold = -Inf;
        
    
        if isempty(varargin)
            return;
        end
        
        Len = length(varargin);
        if (Len==1)
            params.PlotTitle = varargin{1};
        end
    
        if (Len == 3)
            params.PlotTitle = varargin{1};
            params.xlab = varargin{2};
            params.ylab = varargin{3};
        end
           