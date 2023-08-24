% 計算最小交換次數
clc;clear all;
inputArray = 200:-1:1;
[minExchanges, swapSequence] = calculateMinExchanges(inputArray);

function [minExchanges, swapSequence] = calculateMinExchanges(inputArray)
    n = length(inputArray);
    visited = false(1, n);
    minExchanges = 0;
    swapSequence = cell(0);

    for i = 1:n
        if ~visited(i)
            j = i;
            cycleSize = 0;
            cycle = [];

            while ~visited(j)
                visited(j) = true;
                cycleSize = cycleSize + 1;
                cycle = [cycle, j];
                j = inputArray(j);
            end

            minExchanges = minExchanges + (cycleSize - 1);
            swapSequence{end+1} = cycle;
        end
    end

    disp(['Minimum number of exchanges: ', num2str(minExchanges)]);
    disp('Swap sequence:');
    for cycleIdx = 1:length(swapSequence)
        cycle = swapSequence{cycleIdx};
        fprintf('Cycle %d: %s\n', cycleIdx, mat2str(cycle));
        
        % Output swaps within the cycle
        for swapIdx = 1:length(cycle) - 1
            fprintf('  Swap %d: %d <-> %d\n', swapIdx, cycle(swapIdx), cycle(swapIdx + 1));
        end
    end
end