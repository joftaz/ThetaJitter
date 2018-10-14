function hc = compass2(varargin)
%COMPASS Compass plot.
%   COMPASS(U,V) draws a graph that displays the vectors with
%   components (U,V) as arrows emanating from the origin.
%
%   COMPASS(Z) is equivalent to COMPASS(REAL(Z),IMAG(Z)). 
%
%   COMPASS(U,V,LINESPEC) and COMPASS(Z,LINESPEC) uses the line
%   specification LINESPEC (see PLOT for possibilities).
%
%   COMPASS(AX,...) plots into AX instead of GCA.
%
%   H = COMPASS(...) returns handles to line objects in H.
%
%   Example:
%      Z = eig(randn(20,20));
%      compass(Z)
%
%   See also ROSE, FEATHER, QUIVER.

%   Charles R. Denham, MathWorks 3-20-89
%   Modified, 1-2-92, LS.
%   Modified, 12-12-94, cmt.
%   Copyright 1984-2005 The MathWorks, Inc.

% Parse possible Axes input
narginchk(1,4);
[cax,args,nargs] = axescheck(varargin{:});

scalex = 0.1;
scaley = 0.2;
xx = [0 1 1-scalex 1 1-scalex].';
yy = [0 0 scaley/10 0 -scaley/10].';
arrow = xx + yy.*sqrt(-1);

if nargs == 2
    x = args{1};
    y = args{2};
    if ischar(y)
        s = y;
        x = datachk(x);
        y = imag(x); x = real(x);
    else
        s = [];
    end
elseif nargs == 1
    x = args{1}; 
    s = [];
    x = datachk(x);
    y = imag(x); x = real(x);
else % nargs == 3
    [x,y,s] = deal(args{1:3});
end

x = x(:);
y = y(:);
if length(x) ~= length(y)
    error(message('MATLAB:compass:LengthMismatch'));
end
x = datachk(x);
y = datachk(y);

z = (x + y.*sqrt(-1)).';
a = arrow * z;

% Create plot
cax = newplot(cax);

next = lower(get(cax,'NextPlot'));
isholdon = ishold(cax);
[th,r] = cart2pol(real(a),imag(a));

if isempty(s)
    h = polar(cax,th,r);
    co = get(cax,'colororder');
    set(h,'color',co(1,:))
else
    h = polar(cax,th,r,s);
end

if ~isholdon, set(cax,'NextPlot',next); end

if nargout == 1
    hc = h;
end

% Register handles with m-code generator
if ~isempty(h)
   makemcode('RegisterHandle',h,'IgnoreHandle',h(1),'FunctionName','compass');
end

axis square;
set(gca, 'XLim', [-1.1 1.1], 'YLim', [-1.1 1.1])
set(gca,'box','off')
set(gca,'xtick',[])
set(gca,'ytick',[])
text(1.2, 0, '0'); text(-.05, 1.2, '\pi/2');  text(-1.35, 0, '±\pi');  text(-.075, -1.2, '-\pi/2');

function y = datachk(x, kind)
%DATACHK Convert input to appropriate data for plotting
%  Y=DATACHK(X) creates a full, double array from X and returns it in Y.
%  If X is a cell array each element is converted elementwise.
%  Y=DATACHK(..., KIND) customizes the check depending on KIND. KIND
%  can be
%    'double' (default): outputs are converted to full double
%    'numeric':          outputs are numeric and allow conversion to 
%                        double for non-numeric values. Double values are made full.

%   Copyright 1984-2016 The MathWorks, Inc. 

if nargin == 1
    kind = 'double';
end
if iscell(x)
    y = cellfun(@(n)datachk(n,kind),x,'UniformOutput',false);
elseif isa(x,'double')
    y = full(x);
elseif strcmp(kind,'numeric') && isnumeric(x)
    y = x;
else
    try
        y = full(double(x));
    catch
        throwAsCaller(MException(message('MATLAB:specgraph:private:specgraph:nonNumericInput')));
    end
end
