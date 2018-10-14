function s = BiPolarGenerator(t, width, start)
%% N200Generator in [ms]
if nargin < 3
    start = 200;
end
sig = width/2/3; %99.7 of the gaussian.
pos_gaus = gaussmf(t, [sig, start+width]);
neg_gaus = -gaussmf(t, [sig, start+width/2]);
s = pos_gaus + neg_gaus;

end