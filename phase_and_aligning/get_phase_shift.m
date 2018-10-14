function phase_shift = get_phase_shift(phases, start_index_phase, freq_index, freqs, SamplingInterval)
use_diff = false;
if use_diff
    original_phases_diff = diff(phases,1,2);
    %     we interested now only in several frequency
    original_phases_diff = original_phases_diff(freq_index,:,:);
    % the first occurance of original_phases_diff < -1 in each freq and trial
    [~,phase_shift] = max(original_phases_diff(:, start_index_phase:end, :) < -1,[],2);
    phase_shift = mean(squeeze(phase_shift),1);
    phase_shift = phase_shift-mean(phase_shift);
else
    freq = mean(freqs(freq_index));
    phase_shift = squeeze(mean_angle(phases(freq_index, start_index_phase, :),1));
    phase_shift= phase_shift./freq./(2*pi)/SamplingInterval*1e6;
%     phase_shift = bsxfun(@rdivide, squeeze(phases(freq_index, start_index_phase, :))', freqs(freq_index));
%     phase_shift = phase_shift./(2*pi)/SamplingInterval*1e6;
%     if length(freq_index)>1
%         phase_shift = mean(phase_shift,2);
%     end
    phase_shift = phase_shift-mean(phase_shift);
end

phase_shift = round(phase_shift);

end

function u = mean_angle(phi,dim)
	u = angle(mean(exp(1i*phi),dim));
end
