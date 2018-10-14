function varargout = plot(varargin)
    % Override builtin plot and honors the following settings of the
    % graphics root that builtin plot for some reason ignores:
    %   'DefaultAxesBox'
    %   'DefaultAxesTickDir'
    h=builtin('plot',varargin{:});
    ax = get(h,'Parent');
    if iscell(ax)
        ax = ax{1};
    end
    set(ax,'Box',get(groot,'defaultAxesBox'));
    set(ax,'TickDir',get(groot,'defaultAxesTickDir'));
    if nargout > 0
        varargout{1}=h;  
    end
end