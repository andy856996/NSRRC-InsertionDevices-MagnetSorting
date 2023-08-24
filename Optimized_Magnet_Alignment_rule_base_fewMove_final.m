%% Optimized Magnet Alignment
% Optimized Magnet Alignment
% Created by Ding Ze-An
% National Taitung Uni. IPGIT
% Date: 20 Aug. 2023
% Email: andy856996@gmail.com
clc;clear all;
%% load data
load('data.mat')
arrary = arrary(:,1);
%% init parameter
arrary = arrary';
shift_arr = [arrary(2:end) 0];
gradient_arr = shift_arr - arrary;
gradient_arr(1) = [];gradient_arr(end-1:end) = [];
arrary_value = [arrary(2:end-1)];
magnet_idx = 1:length(gradient_arr);
init_value = arrary(2);
%% plot the figure
figure;subplot(2,1,1);plot(arrary,'-o');yline(0.5);yline(-0.5);xlim([1 length(arrary)]);
xlim([1 length(arrary)]);ylim([-2 2]);title('Origin data');set(gca,'FontSize',20,'FontName','Times New Roman');

magnet_locate = [];
gradientAndIdx_org = [magnet_idx;gradient_arr];
arr_out = init_value;
gradient_arr_org = gradient_arr;
tic;
outLimit_arr = arrary_value > 0.5 | arrary_value < -0.5;
idx_outLimit = find(outLimit_arr == 1) -1;

gradientAndIdx_swap = gradientAndIdx_org;
arrary_value_mod = arrary_value;
%% print origin parameter
disp(['(origin) out of the criterion(number) : ' num2str(length(find(arrary_value_mod > 0.5 | arrary_value_mod < -0.5)))])
disp(['(origin) standard deviation (ABS) : ' num2str(std(abs(arrary_value_mod)))])

gradient_new = [];

idx_current = find(arrary_value_mod > 0.5 | arrary_value_mod < -0.5);
idx_last = idx_current - 1;
%% ----------------------> the magnet you want to move
idx = unique([idx_current idx_last]); 
%% start move magnet
idx_current_continuousSequence = continuousSequence2cell(idx_current);
for j = 1:length(idx_current_continuousSequence)
    
    idx_arr = idx_current_continuousSequence{j};

    combinations = [nchoosek(idx, length(idx_current_continuousSequence{j})+1)' ...
        flipud(nchoosek(idx, length(idx_current_continuousSequence{j})+1)')];
    
    current_magMod2_arr = [idx_arr(1)-1 idx_arr];
    arr = [];sum_arr = zeros(1,size(combinations,2));
    odd_even_factor_cell = [];
    for k = 1:size(combinations,1)
        current_magMod2 = mod(current_magMod2_arr(k),2);
        mod_arr = mod(combinations(k,:),2);
        odd_even_factor_arr = (mod_arr ~= current_magMod2)*-1;
        odd_even_factor_arr(odd_even_factor_arr == 0) = 1;
        odd_even_factor_cell{k} = odd_even_factor_arr;
        arr = [arr;gradientAndIdx_swap(2,combinations(k,:)).*odd_even_factor_arr];
        sum_arr = sum_arr + gradientAndIdx_swap(2,combinations(k,:)).*odd_even_factor_arr;
    end

    desire_gradient = arrary_value_mod(idx_arr(end)+1) - arrary_value_mod(idx_arr(1)-1);
    
    arr_tmp = arr;combinations_tmp = combinations;sum_arr_tmp = sum_arr;criterion = 0.5;
    odd_even_factor_cell_tmp = odd_even_factor_cell;
    while 1
        rm_idx = [];
        last_plus_lastGradient = arrary_value_mod(idx_arr(1)-1) + arr(1,:);
        for k = 2:size(arr,1)
            rm_idx = [rm_idx find(last_plus_lastGradient > criterion | last_plus_lastGradient < -criterion)];
            last_plus_lastGradient = last_plus_lastGradient + arr(k,:);
        end
        rm_idx = [rm_idx find(last_plus_lastGradient > criterion | last_plus_lastGradient < -criterion)];
        rm_idx = unique(rm_idx);
        arr(:,rm_idx) = [];combinations(:,rm_idx) = [];sum_arr(:,rm_idx) = [];
        
        for k = 1:size(arr,1)
            odd_even_factor_cell_arr_rm = odd_even_factor_cell{k};
            odd_even_factor_cell_arr_rm(rm_idx) = [];
            odd_even_factor_cell{k} = odd_even_factor_cell_arr_rm;
        end

        [~,I] = min(abs(sum_arr - desire_gradient));
        if ~isempty(I)
            break;
        else
            arr = arr_tmp;combinations = combinations_tmp;sum_arr = sum_arr_tmp;
            odd_even_factor_cell = odd_even_factor_cell_tmp;
            criterion = criterion + 0.1;
        end
    end

    I = I(1);
    

    idx_combinations = 1;
    for k = [idx_arr(1)-1 idx_arr]
        odd_even_factor_arr = odd_even_factor_cell{idx_combinations};
        gradient_cell{k} = [gradientAndIdx_swap(1,combinations(idx_combinations,I)) ...
            gradientAndIdx_swap(2,combinations(idx_combinations,I)).*odd_even_factor_arr(I)];
        idx(idx == combinations(idx_combinations,I)) = [];
        idx_combinations = idx_combinations + 1;
    end
end
gradient_new = [];magnet_locate = [];
for j = 1:length(gradient_arr)
    gradient_cell_arr = gradient_cell{j};
    if isempty(gradient_cell_arr)
        gradient_new = [gradient_new gradient_arr(j)];
        magnet_locate = [magnet_locate gradientAndIdx_swap(1,j)];
    else
        gradient_new = [gradient_new gradient_cell_arr(2)];
        magnet_locate = [magnet_locate gradient_cell_arr(1)];
    end
end
gradientAndIdx_swap = [magnet_locate;gradient_new];
arrary_value_mod = cumsum([init_value gradient_new]);
gradient_arr = gradient_new;
%% caculate the minimum exchanges
disp('--------------------------')
toc;
view_exchange_process = 1; % if you want to see the process of change magnet ,the value must to 1
[minExchanges, swapSequence] = calculateMinExchanges(magnet_locate,view_exchange_process);
disp(['out of the criterion(number) : ' num2str(length(find(arrary_value_mod > 0.5 | arrary_value_mod < -0.5)))]);
disp(['standard deviation (ABS) : ' num2str(std(abs(arrary_value_mod)))]);
%% plot the figure
figure;subplot(2,1,1);plot(arrary,'-o');yline(0.5);yline(-0.5);xlim([1 length(arrary)]);
xlim([1 length(arrary)]);ylim([-2 2]);title('Origin data');set(gca,'FontSize',20,'FontName','Times New Roman');

hold on;subplot(2,1,2);plot([arrary(1) arrary_value_mod arrary(end)],'-o');
yline(0.5);yline(-0.5);xlim([1 length(arrary)]);ylim([-2 2]);title('Magnet sorting w/ rule base');
set(gca,'FontSize',20,'FontName','Times New Roman');
%% verify
arr_verify = [];
for i = 1:length(magnet_locate)
    if magnet_locate(i) == i
        arr_verify = [arr_verify gradient_arr_org(i)];
    else
        if mod(i,2) ~= mod(magnet_locate(i),2)
            arr_verify = [arr_verify gradient_arr_org(magnet_locate(i))*-1];
        else
            arr_verify = [arr_verify gradient_arr_org(magnet_locate(i))];
        end
    end
end
figure;plot([arrary(1) cumsum([init_value arr_verify]) arrary(end)],'-o');yline(0.5);yline(-0.5);xlim([1 length(arrary_value_mod)]);
hold on;plot([arrary(1) arrary_value_mod arrary(end)],'-o');
