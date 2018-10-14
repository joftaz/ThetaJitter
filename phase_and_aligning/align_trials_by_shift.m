function trials = align_trials_by_shift(trials, phase_shift)
trials = squeeze(trials);

trials = bsxfun(@circshift, trials, phase_shift);