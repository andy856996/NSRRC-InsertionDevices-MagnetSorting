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
arrary = arrary(:,1);
% org figure
%figure;plot(arrary,'-o');yline(0.5);yline(-0.5);xlim([1 length(arrary)])

%% init parameter
arrary = arrary';
shift_arr = [arrary(2:end) 0];
gradient_arr = shift_arr - arrary;
gradient_arr(1) = [];gradient_arr(end-1:end) = [];
arrary_value = [arrary(2:end-1)];
magnet_idx = 1:length(gradient_arr);
init_value = arrary(2);

magnet_locate = [];
gradientAndIdx_org = [magnet_idx;gradient_arr];
arr_out = init_value;
tic;
%figure;plot(arrary_value,'-o');yline(0.5);yline(-0.5);xlim([1 length(arrary)])
outLimit_arr = arrary_value > 0.5 | arrary_value < -0.5;
idx_outLimit = find(outLimit_arr == 1) -1;


swap_limit = 100;
i = 1;
gradientAndIdx_swap = gradientAndIdx_org;
arrary_value_mod = arrary_value;
figure;plot(arrary_value_mod,'-o');yline(0.5);yline(-0.5);xlim([1 length(arrary_value_mod)]);
while i < swap_limit + 1

    [Max_arr,max_idx] = max(abs(arrary_value_mod));
    max_idx_x = max_idx -1;
    max_idx_xPlus1 = max_idx;

    replace_gradient = arrary_value_mod(max_idx_xPlus1+1) - arrary_value_mod(max_idx_x);

    [~,replace_idx] = min(abs(gradientAndIdx_swap(2,max_idx_x:end) - replace_gradient));
    
    replace_idx = replace_idx + max_idx_x -1;

    tmp = gradientAndIdx_swap(:,max_idx_x);

    gradientAndIdx_swap(:,max_idx_x) = gradientAndIdx_swap(:,replace_idx);
    
    gradientAndIdx_swap(:,replace_idx) = tmp;

    arrary_value_mod = cumsum([init_value gradientAndIdx_swap(2,:)]);
    hold on;plot(arrary_value_mod,'-o');yline(0.5);yline(-0.5);xlim([1 length(arrary_value_mod)]);
    i = i + 1;
end



[minExchanges, swapSequence] = calculateMinExchanges(magnet_locate,0);
toc;
% 畫圖
figure;subplot(2,1,1);plot(arrary,'-o');yline(0.5);yline(-0.5);xlim([1 length(arrary)]);
xlim([1 length(arrary)]);ylim([-2 2]);title('Origin data');set(gca,'FontSize',20,'FontName','Times New Roman');

hold on;subplot(2,1,2);plot([arrary(1) arr_out arrary(end)],'-o');
yline(0.5);yline(-0.5);xlim([1 length(arrary)]);ylim([-2 2]);title('Magnet sorting w/ rule base');
set(gca,'FontSize',20,'FontName','Times New Roman');