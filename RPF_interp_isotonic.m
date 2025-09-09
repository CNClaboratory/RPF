function y_isotonic = RPF_interp_isotonic(x, y, varargin)
% Performs isotonic regression using the PAVA algorithm.
% y_isotonic = ISOTONIC_REGRESSION_PAVA(x, y) fits a non-decreasing isotonic
% regression to the data points (x, y).
%
% y_isotonic = ISOTONIC_REGRESSION_PAVA(x, y, 'decreasing') fits a non-increasing
% isotonic regression.
%
% Inputs:
%   x: Independent variable data (vector).
%   y: Dependent variable data (vector), same size as x.
%   varargin: Optional arguments:
%               'decreasing' - If present, performs non-increasing regression.
%
% Output:
%   y_isotonic: The isotonic regression fit.
%               The values correspond to the original x order.
%
% Note: This function does not implement weighting or duplicate-x pooling,
% since its use case is specific to the RPF methodology in which exactly
% one x value (stimulus level or strength) should produce exactly one P1
% value, so duplicate x-values should not occur.

    % Input validation
    if ~isvector(x) || ~isvector(y) || numel(x) ~= numel(y)
        error('Inputs x and y must be vectors of the same size.');
    end
    if any(isnan(x)) || any(isnan(y)), error('For isotonic regression, x and y must not contain NaNs.'); end
    if isrow(x), x = x'; end % Ensure column vector
    if isrow(y), y = y'; end % Ensure column vector

    % Store original order to re-sort later
    original_indices = (1:numel(x))';

    % Sort data based on x. This is crucial for PAVA.
    [x_sorted, sort_idx] = sort(x);
    y_sorted = y(sort_idx);
    original_indices_sorted = original_indices(sort_idx);

    % Determine if regression should be non-decreasing (default) or non-increasing
    is_decreasing = false;
    if nargin > 2 && ischar(varargin{1}) && strcmpi(varargin{1}, 'decreasing')
        is_decreasing = true;
        % For decreasing regression, invert y, perform non-decreasing PAVA, then invert back
        y_sorted = -y_sorted;
    end

    % Initialize the isotonic values with the sorted y values
    y_isotonic_sorted = y_sorted;

    % PAVA Algorithm Implementation
    % This implementation uses a stack-like approach for efficiency.
    % It maintains pools of averaged values.

    n = numel(y_isotonic_sorted);
    
    % 'blocks' stores the current pools. Each row is [start_index, end_index, mean_value]
    % 'blocks_count' tracks how many active blocks there are
    blocks = zeros(n, 3);
    blocks_count = 0;

    for i = 1:n
        % Start a new block for the current element
        blocks_count = blocks_count + 1;
        blocks(blocks_count, :) = [i, i, y_isotonic_sorted(i)];

        % While the current block's mean is less than the previous block's mean
        % (violation for non-decreasing), merge them.
        while blocks_count > 1 && blocks(blocks_count, 3) < blocks(blocks_count - 1, 3)
            % Get previous block's info
            prev_start = blocks(blocks_count - 1, 1);
            prev_end = blocks(blocks_count - 1, 2);
            prev_mean = blocks(blocks_count - 1, 3);

            % Get current block's info
            curr_start = blocks(blocks_count, 1);
            curr_end = blocks(blocks_count, 2);
            curr_mean = blocks(blocks_count, 3);

            % Calculate the new combined mean (weighted average)
            new_mean = (prev_mean * (prev_end - prev_start + 1) + ...
                        curr_mean * (curr_end - curr_start + 1)) / ...
                       ((prev_end - prev_start + 1) + (curr_end - curr_start + 1));

            % Update the previous block with the merged information
            blocks(blocks_count - 1, :) = [prev_start, curr_end, new_mean];
            
            % Decrement blocks_count as two blocks merged into one
            blocks_count = blocks_count - 1;
        end
    end

    % Assign the averaged values back to y_isotonic_sorted
    for k = 1:blocks_count
        start_idx = blocks(k, 1);
        end_idx = blocks(k, 2);
        mean_val = blocks(k, 3);
        y_isotonic_sorted(start_idx:end_idx) = mean_val;
    end

    % If it was a decreasing regression, invert values back
    if is_decreasing
        y_isotonic_sorted = -y_isotonic_sorted;
    end

    % Reorder y_isotonic_sorted back to the original order of y
    % Create a mapping from sorted indices back to original indices
    [~, original_order_map] = sort(sort_idx);
    y_isotonic = y_isotonic_sorted(original_order_map);

end