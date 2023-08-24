

% Example usage
inputArray = [1 4 5 3 2];
minExchanges = calculateMinExchanges(inputArray);

disp(['Minimum number of exchanges: ', num2str(minExchanges)]);

function minExchanges = calculateMinExchanges(inputArray)
    n = length(inputArray);
    visited = false(1, n);
    minExchanges = 0;

    for i = 1:n
        if ~visited(i)
            j = i;
            cycleSize = 0;
            while ~visited(j)
                visited(j) = true;
                j = inputArray(j);
                cycleSize = cycleSize + 1;
            end
            minExchanges = minExchanges + (cycleSize - 1);
        end
    end
end
