function mat = N200matWithNoise(t, rep_num, noise)
%% generates matrix with samples with noise
fs = length(t)/(length(t)-1)/(t(2)-t(1));
BasicGen = @(width) N200Generator(fs, min(t), max(t), width);

mat = zeros(rep_num, length(t));

%scale
width_vector = randi([noise.tscales(1) noise.tscales(2)],rep_num,1)';
for ii = 1:rep_num
    mat(ii,:) = BasicGen(width_vector(ii));
end
mat2 = circshift(mat, [0,-round(10*fs)]);
mat = (mat-mat2).*4;

%noise
% pink_noise = dsp.ColoredNoise('InverseFrequencyPower',2,'NumChannels',rep_num,...
%                       'SamplesPerFrame',size(mat,2));
mat = mat + pinknoise(size(mat,2),noise.pink_alpha,rep_num);

% jitter
jitter_vector = randi([-noise.jitter/2,noise.jitter/2],rep_num,1)';
mat = bsxfun(@circshift, mat', jitter_vector);

%amplitue
b = noise.amplitude(2);
a = noise.amplitude(1);
amp_vector = rand(rep_num,1)'.*(b-a)+a; %rand [a-b]

mat = bsxfun(@times, mat, amp_vector)';

