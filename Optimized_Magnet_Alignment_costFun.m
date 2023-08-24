function E = Optimized_Magnet_Alignment_costFun(x,init_value,gradient_arr,arrary,magnet_idx)
% Optimized Magnet Alignment
% Created by Ding Ze-An
% National Taitung Uni. IPGIT
% Date: 20 Aug. 2023
% Email: andy856996@gmail.com
global table_save E_arr
x = round(x);
%[C,ia,ic] = unique(x);% 
[diff_value,idx_diff] = setdiff(magnet_idx,x);
[intersect_value,idx_intersect]  = intersect(magnet_idx,x);

diff_idx = 1;
for i = 1:length(intersect_value)

    if length(x(x == intersect_value(i)))>1

        idx = find(x == intersect_value(i));
        for j = 2:length(idx)
            x(idx(j)) = diff_value(diff_idx);
            diff_idx = diff_idx + 1;
        end

    end

end

reSort_arr = gradient_arr(x);
out_arr = init_value;
for i = 2:length(reSort_arr)
    out_arr(i) = out_arr(i-1) + reSort_arr(i);
end
E = std(out_arr) + length(find(out_arr>0.5 | out_arr<-0.5 ));
E_arr = [E_arr E];

if E < min(E_arr(1:end-1))
    table_save = out_arr;
end

end