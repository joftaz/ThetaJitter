ind = 25;
result = results{ind};
trials = result.trials;
trials = bsxfun(@minus, trials, mean(trials(bl_range,:,:)));
n_segs = size(trials, 3);
man_shifts = zeros(1,n_segs);
figure;
varplot(t, squeeze(trials(u,1,:)))
figure;
for ii = 1:n_segs
    plot(t, squeeze(trials(u,1,ii)));
    title(num2str(ii))
    [x,y] = ginput(1);
    man_shifts(ii) = find(times>x,1);
end