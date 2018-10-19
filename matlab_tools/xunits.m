function [ t ] = xunits(varargin)
%% creates units for the x axis
% units - units to show
% varargin - any text name-value parameters
if ishandle(varargin{1})
    h = varargin{1};
    varargin = varargin{2:end};
else
    h = gca;
end
if length(varargin) > 1 && strcmp(varargin{2},'replace')
    replace = true;
else
    replace = false;
end
units = varargin{1};

if ~replace
    text_args = [{1,-0.1, units, 'units', 'normalized','HorizontalAlignment','right','clipping','off'}, varargin{2:end}];
    if nargout > 0
        t = text(h,text_args{:});
    else
        text(h,text_args{:});
    end
else
    h.XTickLabel{end} = units;
end



