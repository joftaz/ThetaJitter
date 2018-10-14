function shifts = get_shift_by_zero_cross(t, trails, ERP, first_region, stretch, second_region, show_res)
set_default('stretch',false)
set_default('first_region', [0,300])
set_default('second_region', [400,600])
set_default('show_res', false)

first_mask = zeros(size(t));
first_mask(t>first_region(1) & t<first_region(2)) = 1;
second_mask = zeros(size(t));
second_mask(t>second_region(1) & t<second_region(2)) = 1;
 
first_gt = find_zero_before_max(ERP);
first_zc = find_zero_before_max(trails);

shifts = first_gt - first_zc;
if stretch
    gt2 = find_zero_after_max(ERP);
    zc2 = find_zero_after_max(trails);
    shifts(:,2) = gt2 - zc2;
end

function inds = find_zero_before_max(vec) 
    [~, mi] = max(vec.*first_mask,[],2);
    max_mask = 1:size(vec,2);
    max_mask = max_mask < mi*first_mask;
    v = vec.*max_mask;
    [~, idx] = max(fliplr(v.*circshift(v, [0 -1]) < 0), [], 2);
    idx(idx==1) = nan;
    inds = size(v,2) - idx;
    if show_res
        show_and_wait(vec, inds, first_mask, max_mask)
    end
end

function inds = find_zero_after_max(vec) 
    [~, mi] = max(vec.*second_mask,[],2);
    max_mask = 1:size(vec,2);
    max_mask = bsxfun(@gt, max_mask, mi);
    max_mask = max_mask.*second_mask;
    v = vec.*max_mask;
    [~, idx] = max(v.*circshift(v, [0 -1]) < 0, [], 2);
    inds = idx;
end

    function show_and_wait(vec, idx, basic_mask, max_mask)
        for ii=1:length(idx)            
            plot(t,vec(ii,:))
            hold on
            plot(t,vec(ii,:).*basic_mask)
            plot(t,vec(ii,:).*max_mask(ii,:))
            if ~isnan(idx(ii))
                plot(t(idx(ii)),vec(ii,idx(ii)),'x')
            else
                plot(t(1),vec(ii,1),'x')
            end
            title(ii)
            legend({'raw', 'basic mask', 'max mask', 'idx'})
            hold off
            
            % do not move on until enter key is pressed
            pause; % wait for a keypress
            currkey=get(gcf,'CurrentKey'); 
            if currkey=='q'
                break;
            end
        end
    end

end
