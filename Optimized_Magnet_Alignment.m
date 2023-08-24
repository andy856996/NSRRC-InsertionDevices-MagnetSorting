% Optimized Magnet Alignment
% Created by Ding Ze-An
% National Taitung Uni. IPGIT
% Date: 20 Aug. 2023
% Email: andy856996@gmail.com
clc;clear all;
global table_save E_arr
%% Optimized Magnet Alignment
%arrary = [];
load('matlab.mat')
% org figure
figure;plot(arrary,'-');yline(0.5);yline(-0.5);
%% init parameter
arrary = arrary';
shift_arr = [arrary(2:end) 0];
gradient_arr = shift_arr - arrary;
gradient_arr(1) = [];gradient_arr(end-1:end) = [];

magnet_idx = 1:length(gradient_arr);
init_value = arrary(2);
%% opt parameter set up
LB = ones(1,length(gradient_arr));
UB = ones(1,length(gradient_arr)).*length(gradient_arr);

% options = optimoptions('particleswarm','SwarmSize',1000,'Display','iter');
% tic
% [x,E,~,~] =particleswarm(@(x)Optimized_Magnet_Alignment_costFun(x,init_value,gradient_arr,arrary,magnet_idx),length(gradient_arr),LB,UB,options);
% toc
%% opt using GA
 options = optimoptions( ...
     'ga', ...                                    % 最佳化算法
     'PopulationSize', 1000, ...                    % 染色體數量
     'MaxGenerations', 10000, ...                   % 最大繁衍代數 
     'PlotFcn', {@gaplotbestf,@gaplotstopping}, ...     % 繪圖函數%'PlotFcn', {@gaplotbestf}, ... 
     'CrossoverFraction', 0.05, ...                % 交配率
     'Display', 'iter');                         % 結果展示方式

%options=gaoptimset('Display','iter','TolFun',1e-20,'TolCon',1e-20);
[x, fval] = ga(@(x)Optimized_Magnet_Alignment_costFun(x,init_value,gradient_arr,arrary,magnet_idx),length(gradient_arr), [], [], [], [], ...
    LB,UB, [], [], options);
%% plot final out
figure;plot(table_save,'-');yline(0.5);yline(-0.5)