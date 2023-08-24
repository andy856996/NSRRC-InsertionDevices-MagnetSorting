%% Optimized Magnet Alignment
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

magnet_locate = [];
gradientAndIdx_org = [magnet_idx;gradient_arr];
arr_out = init_value;
tic;
for i = 1:length(magnet_idx)-1
    % Get upper and lower intervals
    upperLimit = 0.5 - arr_out(i);
    downLimit = -(arr_out(i) + 0.5);
    gradientAndIdx = gradientAndIdx_org;
    % Single and double change need to change 
    if mod(i,2) == 1 % odd
        gradientAndIdx(2,mod(gradientAndIdx(1,:),2) == 0) = ...
            gradientAndIdx(2,mod(gradientAndIdx(1,:),2) == 0) * -1;
    else
        gradientAndIdx(2,mod(gradientAndIdx(1,:),2) == 1) = ...
            gradientAndIdx(2,mod(gradientAndIdx(1,:),2) == 1) * -1;
    end
    % Find out the values ​​that can be inserted
    idx = find( (gradientAndIdx(2,:)<upperLimit) & (gradientAndIdx(2,:)>downLimit) );
    if isempty(idx) % Relax the limit if there is no suitable value from upperLimit to downLimit
        while isempty(idx) 
            if (upperLimit > 0) && (downLimit > 0) || (upperLimit < 0) && (downLimit < 0)
                idx = 1;
                break;
            end
            upperLimit = upperLimit + (upperLimit * 0.01);
            downLimit = downLimit + (downLimit * 0.01);
            idx = find( (gradientAndIdx(2,:)<upperLimit) & (gradientAndIdx(2,:)>downLimit) );

        end
    end
    
    gradientAndIdx_insert = gradientAndIdx(:,idx);
    [~,idx_max] = max(abs(gradientAndIdx_insert(2,:)));
    idx_rm = find(gradientAndIdx_org(1,:) == gradientAndIdx_insert(1,idx_max));
    gradientAndIdx_org(:,idx_rm) = [];
    arr_out = [arr_out (arr_out(i) + gradientAndIdx_insert(2,idx_max))];
    magnet_locate = [magnet_locate gradientAndIdx_insert(1,idx_max)];
end
toc;
% plot figure
figure;subplot(2,1,1);plot(arrary,'-o');yline(0.5);yline(-0.5);xlim([1 length(arrary)]);
xlim([1 length(arrary)]);ylim([-2 2]);title('Origin data');set(gca,'FontSize',20,'FontName','Times New Roman');

hold on;subplot(2,1,2);plot([arrary(1) init_value arr_out arrary(end)],'-o');
yline(0.5);yline(-0.5);xlim([1 length(arrary)]);ylim([-2 2]);title('Magnet sorting w/ rule base');
set(gca,'FontSize',20,'FontName','Times New Roman');