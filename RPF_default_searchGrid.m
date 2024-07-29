function searchGrid = RPF_default_searchGrid(info)
% searchGrid = RPF_default_searchGrid(info)
%
% This function sets default settings of searchGrid for undefined fields,
% and overwrites any pre-specified searchGrid fields that are inconsistent 
% with the constrain struct
%
% INPUTS
% ------
% info - the info struct, which is assumed to already contain the searchGrid
%    struct as a field if any settings in searchGrid are intended to be pre-
%    specified. see RPF_guide('info') and RPF_guide('searchGrid') for more.
%
% OUTPUTS
% -------
% searchGrid - an updated searchGrid struct. see RPF_guide('searchGrid')

%% prepare

% unpack structs
constrain = info.constrain;

if isfield(info, 'searchGrid')
    searchGrid = info.searchGrid;
else
    searchGrid = [];
end

% determine whether to use scaled or unscaled PF defaults
switch info.fit_type
    case 'interp'
        searchGrid = [];
        return

    case 'SSE'
        scaled_PF = 1;

    otherwise

        switch info.DV
            case {'p(correct)', 'p(response)', 'p(high rating)', 'mean rating'}
                scaled_PF = 0;

            case {'d''', 'meta-d''', 'type 2 AUC', 'RT'}
                scaled_PF = 1;
        end
end

%% alpha

% if alpha constraint is defined, set searchGrid.alpha to that constraint
if isstruct(constrain) && isfield(constrain, 'value') && isfield(constrain.value, 'alpha') && ~isempty(constrain.value.alpha)
    searchGrid.alpha = constrain.value.alpha;

% if alpha constraint is not defined, 
% and if searchGrid.alpha has not been manually defined by the user,
% then set searchGrid.alpha to its default value
elseif ~isstruct(searchGrid) || (~isfield(searchGrid, 'alpha') || isempty(searchGrid.alpha)) 
    searchGrid.alpha = .05:.05:3;
    
    % transform alpha according to the appropriate x transform
    searchGrid.alpha = info.xt_fn( searchGrid.alpha );
end

%% beta

% if beta constraint is defined, set searchGrid.beta to that constraint
if isstruct(constrain) && isfield(constrain, 'value') && isfield(constrain.value, 'beta') && ~isempty(constrain.value.beta)
    searchGrid.beta = constrain.value.beta;

% if beta constraint is not defined, 
% and if searchGrid.beta has not been manually defined by the user,
% then set searchGrid.beta to its default value
elseif ~isfield(searchGrid, 'beta') || isempty(searchGrid.beta)
    searchGrid.beta = 10.^(-1:.1:1);
end

%% gamma

% if gamma constraint is defined, set searchGrid.gamma to that constraint
if isstruct(constrain) && isfield(constrain, 'value') && isfield(constrain.value, 'gamma') && ~isempty(constrain.value.gamma)
    searchGrid.gamma = constrain.value.gamma;

% if gamma constraint is not defined, 
% and if searchGrid.gamma has not been manually defined by the user,
% then set searchGrid.gamma to its default value
elseif ~isfield(searchGrid, 'gamma') || isempty(searchGrid.gamma)
    
    if scaled_PF
        searchGrid.gamma = linspace(info.P_min, info.P_max, 11);
    else
        searchGrid.gamma  = 0:.1:1;
    end
    
end

%% lambda (for unscaled PFs)

if scaled_PF == 0
    
    % if lambda constraint is defined, set searchGrid.lambda to that constraint
    if isstruct(constrain) && isfield(constrain, 'value') && isfield(constrain.value, 'lambda') && ~isempty(constrain.value.lambda)
        searchGrid.lambda = constrain.value.lambda;

    % if lambda constraint is not defined, 
    % and if searchGrid.lambda has not been manually defined by the user,
    % then set searchGrid.lambda to its default value
    elseif ~isfield(searchGrid, 'lambda') || isempty(searchGrid.lambda)
        searchGrid.lambda = 0:.1:1;
    end
    
end

%% omega (for scaled PFs)

if scaled_PF == 1
    
    % if omega constraint is defined, set searchGrid.omega to that constraint
    if isstruct(constrain) && isfield(constrain, 'value') && isfield(constrain.value, 'omega') && ~isempty(constrain.value.omega)
        searchGrid.omega = constrain.value.omega;

    % if omega constraint is not defined, 
    % and if searchGrid.omega has not been manually defined by the user,
    % then set searchGrid.omega to its default value
    elseif ~isfield(searchGrid, 'omega') || isempty(searchGrid.omega)
        searchGrid.omega = linspace(info.P_min, info.P_max, 10);
    end
    
end