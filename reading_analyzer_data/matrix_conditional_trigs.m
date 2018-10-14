function [ trigs ] = matrix_conditional_trigs( event_indexes, target, varargin)
% uses OR for several conditions

cond = zeros(nargin/2-1,2);
for ii = 2:2:nargin-2
    cond(ii/2, 1) = varargin{ii-1};
    cond(ii/2, 2) = varargin{ii};
end

target_inds = ismember(event_indexes(:,1),target);

trigs = [];
for jj = 1:size(cond,1)
    condj_ind = ismember(event_indexes(:,1),cond(jj,1));

    for ii = find(target_inds)'
        val = event_indexes(ii,2);
        if any(val < event_indexes(condj_ind,2) & val > event_indexes(condj_ind,2) + cond(jj,2))
            trigs = [trigs val];
        end
    end

end

if isempty(cond)
    trigs =  event_indexes(target_inds,2);
end

trigs = unique(trigs);