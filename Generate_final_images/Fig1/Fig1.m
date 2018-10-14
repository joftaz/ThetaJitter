%% init numbers 
dt  = 2;
tmax = 1000;
tmin = -200;
fs = 1/dt;
len_sample = floor((tmax-tmin)*fs);
t = linspace(tmin, tmax, len_sample);
N2_width = 200;
jitters = [0 50:50:260];
num_trails = 100;

freqs = logspace(log10(2), log10(60), 30);
n1 = N200Generator(fs, tmin, tmax, N2_width);
n2 = circshift(n1, [1,-30*fs]);
baseN2 = (n1-n2)*2;


%% calculate spectrum 
[p,pha] = getPowerSpectra(baseN2,dt, freqs);

%% show spectrum
figure;
% Enlarge figure to full screen.
% set(gcf, 'units','inch', 'OuterPosition', [4,4, 2.5, 2.5]);
subplot(3,3,5);
show_spectrum(p, t, freqs, 'surf', '', false)

axis square;
 
% add the colorbar, make it prettier

ax = gca;
axpos = ax.Position;

handles = colorbar;
handles.TickDirection = 'out';
handles.Box = 'off';
handles.Label.String = 'Power [Au]';
handles.Ticks = [0,0.04];

% this looks okay, but the colorbar is very wide. Let's change that!
% get original axes
% restore axis pos
ax.Position = axpos;

cpos = handles.Position;
cpos(3) = cpos(3)/2;
set(handles,'Position',cpos);
 
hold on
yyaxis right
yticks([])
plot(t, baseN2 , 'k', 'LineWidth',2)
xlabel 'Time [ms]'

% colors = cbrewer('div', 'RdBu', 64);
colors = cbrewer('seq', 'OrRd', 64);
% colors = flipud(colors); % puts red on top, blue at the bottom
colormap(colors);
 
% when the data are sequential (eg. only going from 0 to positive, use for
% example colors = cbrewer('seq', 'YlOrRd', 64); or the default parula.
% colormap(cbrewer('div', 'RdBu', 128)) 
%% save image
path = fileparts(mfilename('fullpath'));
savefig([path '/' 'Fig1.fig'])
saveas(gcf, [path '/' 'Fig1.png'])
