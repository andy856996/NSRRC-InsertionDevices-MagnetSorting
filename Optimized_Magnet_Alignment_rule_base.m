% Optimized Magnet Alignment
% Created by Ding Ze-An
% National Taitung Uni. IPGIT
% Date: 20 Aug. 2023
% Email: andy856996@gmail.com
clc;clear all;
global table_save E_arr
%% Optimized Magnet Alignment
%arrary = [];
load('data.mat')
% org figure
figure;plot(arrary,'-o');yline(0.5);yline(-0.5);xlim([1 length(arrary)])
%% init parameter
arrary = arrary';
shift_arr = [arrary(2:end) 0];
gradient_arr = shift_arr - arrary;
gradient_arr(1) = [];gradient_arr(end-1:end) = [];
arrary_value = [arrary(2:end-1)];
magnet_idx = 1:length(gradient_arr);
init_value = arrary(2);

arrary_value_opt =  arrary_value;
init_value_opt = init_value;
gradient_arr_opt = gradient_arr;
len_arr = [];
idx = 1;
while 1 
    try
        [min_value,idx_min] = min(arrary_value_opt(2:end));
        [max_value,idx_max] = max(arrary_value_opt(2:end));
        tmp = gradient_arr(idx_min);
        gradient_arr(idx_min) = gradient_arr(idx_max);
        gradient_arr(idx_max) = tmp;
    
        for i = 1:length(arrary_value_opt)
            if i == 1
                arrary_value_opt(i) = init_value;
            else
                arrary_value_opt(i) = arrary_value_opt(i-1) + gradient_arr(i-1);
            end
        end
        %hold on;plot([arrary(1) arrary_value_opt arrary(end)],'-');
        arrary_value_opt_cell{idx} = arrary_value_opt;
        len_arr =[len_arr length(find(arrary_value_opt>0.5 | arrary_value_opt<-0.5))];
        idx = idx + 1;
    catch
        disp('err')
    end

end