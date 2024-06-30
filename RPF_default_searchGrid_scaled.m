function [searchGrid, paramsFree] = RPF_default_searchGrid_scaled(constrain, xt_fn, P_min, P_max)
% [searchGrid, paramsFree] = RPF_default_searchGrid_scaled(constrain, xt_fn, P_min, P_max)


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
%     searchGrid.gamma  = 0:.1:1;
    searchGrid.gamma  = linspace(P_min, P_max, 10);
end

%% omega

if isstruct(constrain) && isfield(constrain, 'value') && isfield(constrain.value, 'omega') && ~isempty(constrain.value.omega)
    % set omega to a fixed value
    searchGrid.omega = constrain.value.omega;

else
    % leave omega as free parameter
%     searchGrid.omega = 1:10;
    searchGrid.omega  = linspace(P_min, P_max, 10);
end
