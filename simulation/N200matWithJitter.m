function mat = N200matWithJitter(x, rep_num, jitter)
%% generates matrix with samples with jitter
X = repmat(x, rep_num, 1)';
jitter_vector = randi(floor([-1,1]*jitter/2),rep_num,1)';
mat = bsxfun(@circshift, X, jitter_vector);

amp_vector = ones(rep_num,1)';
% amp_vector = rand(rep_num,1)'/2+0.5; %rand 0.5-1

mat = bsxfun(@times, mat, amp_vector);

