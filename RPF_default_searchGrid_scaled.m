function searchGrid = RPF_default_searchGrid_scaled(info)
% searchGrid = RPF_default_searchGrid_scaled(info)


%% 

constrain = info.constrain;

%% alpha

if isstruct(constrain) && isfield(constrain, 'value') && isfield(constrain.value, 'alpha') && ~isempty(constrain.value.alpha)
    % set alpha to a fixed value
    searchGrid.alpha = constrain.value.alpha;

else
    % leave alpha as a free parameter
    searchGrid.alpha = .05:.05:3;
    
    % transform alpha according to the appropriate x transform
    searchGrid.alpha = info.xt_fn( searchGrid.alpha );
end

%% beta

if isstruct(constrain) && isfield(constrain, 'value') && isfield(constrain.value, 'beta') && ~isempty(constrain.value.beta)
    % set beta to a fixed value
    searchGrid.beta = constrain.value.beta;

else
    % leave beta as free parameter
    searchGrid.beta  = 10.^(-1:.1:1);
end

%% gamma

if isstruct(constrain) && isfield(constrain, 'value') && isfield(constrain.value, 'gamma') && ~isempty(constrain.value.gamma)
    % set gamma to a fixed value
    searchGrid.gamma = constrain.value.gamma;

else
    % leave gamma as free parameter
%     searchGrid.gamma  = 0:.1:1;
    searchGrid.gamma  = linspace(info.P_min, info.P_max, 10);
end

%% omega

if isstruct(constrain) && isfield(constrain, 'value') && isfield(constrain.value, 'omega') && ~isempty(constrain.value.omega)
    % set omega to a fixed value
    searchGrid.omega = constrain.value.omega;

else
    % leave omega as free parameter
%     searchGrid.omega = 1:10;
    searchGrid.omega  = linspace(info.P_min, info.P_max, 10);
end
