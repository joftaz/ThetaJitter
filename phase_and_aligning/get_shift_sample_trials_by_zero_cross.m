function tot_shift = get_shift_sample_trials_by_zero_cross(t, trials, erp, rep, n_samples, first_region, stretch, second_region, show_res)
set_default('stretch',false)
set_default('first_region', [0,300])
set_default('second_region', [400,600])
set_default('show_res', false)

% basics
trials = squeeze(trials)';
N = size(trials,1);
M = size(trials,2);

% get random matrix
r_mat = randi(N, [n_samples,rep]);
tot_shift = zeros([N, 1]);
tot_count = zeros([N, 1]);
rand_trials = reshape(trials(r_mat,:),[n_samples,rep,M]);
rand_trials = squeeze(mean(rand_trials,1));

% get shifts
shifts_mat = get_shift_by_zero_cross(t,rand_trials,erp',first_region, stretch, second_region, show_res);

% fix accordingly
for ii = 1:rep
    r = r_mat(:,ii);
    shifts = shifts_mat(ii);
    if isnan(shifts)
        continue
    end
    tot_shift(r) = tot_shift(r) + shifts;
    tot_count(r) = tot_count(r) + 1;
end
tot_shift = tot_shift ./ tot_count;
tot_shift = round(tot_shift);


% if stretch
%     gt2 = find_zero_after_max(erp);
%     zc2 = find_zero_after_max(squeeze(trials)');
%     shifts(:,2) = gt2 - zc2;
% end


end
