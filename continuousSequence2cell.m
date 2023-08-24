function continuous_sequences = continuousSequence2cell(nums)
continuous_sequences = {};

% 開始第一個連續序列
current_sequence = [nums(1)];

for i = 2:length(nums)
    if nums(i) == nums(i-1) + 1
        current_sequence = [current_sequence, nums(i)];
    else
        continuous_sequences{end+1} = current_sequence; % 將連續序列加入 cell 陣列
        current_sequence = [nums(i)]; % 開始新的連續序列
    end
end

% 將最後一個連續序列加入 cell 陣列
continuous_sequences{end+1} = current_sequence;

% 顯示連續數字序列的 cell 陣列
%disp(continuous_sequences);

end