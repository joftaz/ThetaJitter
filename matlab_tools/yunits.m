function [ t ] = yunits( units, varargin )
%% creates units for the y axis
% units - units to show
% varargin - any text name-value parameters
if ishandle(varargin{1})
    h = varargin{1};
    varargin = varargin{2:end};
else
    h = gca;
end
text_args = [{-0.05,1.05, units, 'units', 'normalized','HorizontalAlignment','right','clipping','off'}, varargin{2:end}];
if nargout > 0
    t = text(h,text_args{:});
else
    text(h,text_args{:});
end

