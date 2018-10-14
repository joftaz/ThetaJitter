function mat = DeltamatWithNoise(t, rep_num, noise)
%% generates matrix with samples with noise\
fs = length(t)/(length(t)-1)/(t(2)-t(1));
BasicGen = @(width) N200Generator(fs, min(t), max(t), width);
BasicP = @(width) N200Generator(fs, min(t), max(t), width, 300);

mat = zeros(rep_num, length(t));
matDelta = mat;
%scale
width_vector = randi([noise.tscales(1) noise.tscales(2)],rep_num,1)';
delta_width_vector = randi([noise.delta_tscales(1) noise.delta_tscales(2)],rep_num,1)';
for ii = 1:rep_num
    mat(ii,:) = BasicGen(width_vector(ii));
    matDelta(ii,:) = BasicP(delta_width_vector(ii));
end
mat2 = circshift(mat, [0,-round(10*fs)]);
mat = (mat-mat2).*4;
mat = mat + circshift(matDelta, [0,-round(10*fs)]);

%noise
pink_noise = dsp.ColoredNoise('InverseFrequencyPower',1,'NumChannels',rep_num,...
                      'SamplesPerFrame',size(mat,2));
mat = mat + pink_noise()' * noise.randn;

% jitter
jitter_vector = randi([-noise.jitter/2,noise.jitter/2],rep_num,1)';
mat = bsxfun(@circshift, mat', jitter_vector);

%amplitue
b = noise.amplitude(2);
a = noise.amplitude(1);
amp_vector = rand(rep_num,1)'.*(b-a)+a; %rand [a-b]

mat = bsxfun(@times, mat, amp_vector)';

