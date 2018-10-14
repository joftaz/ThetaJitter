function s = N200Generator(fs, tmin, tmax, width, start)
%% N200Generator in [ms]
if nargin < 5
    start = 200;
end
alpha = 3;
pre = floor((start-tmin)*fs);
post = floor((tmax-width-start)*fs);
s = gausswin(round(width*fs),alpha)';
s = [zeros(1,pre), s, zeros(1,post)];

end