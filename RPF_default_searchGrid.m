function searchGrid = RPF_default_searchGrid(constrain, xt_fn)
% searchGrid = RPF_default_searchGrid(constrain, xt_fn)


%% define search grid

%% alpha

searchGrid.alpha = .05:.05:3;

% transform alpha according to the appropriate x transform
searchGrid.alpha = xt_fn( searchGrid.alpha );


%% beta

searchGrid.beta  = 10.^(-1:.1:1);

%% gamma

if isstruct(constrain) && isfield(constrain, 'value') && isfield(constrain.value, 'gamma') && ~isempty(constrain.value.gamma)
    % set gamma to a fixed value
    searchGrid.gamma = constrain.value.gamma;

else
    % leave gamma as free parameter
    searchGrid.gamma  = 0:.1:1;
end

%% lambda

if isstruct(constrain) && isfield(constrain, 'value') && isfield(constrain.value, 'lambda') && ~isempty(constrain.value.lambda)
    % set lambda to a fixed value
    searchGrid.lambda = constrain.value.lambda;

else
    % leave gamma as free parameter
    searchGrid.lambda = 0:.1:1;
end