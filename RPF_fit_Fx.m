function fit = RPF_fit_Fx(info, data, constrain, searchGrid)
% fit = RPF_fit_Fx(info, data, constrain, searchGrid)
%
% fit data according to the specifications held in info, subject to
% constraints.
%
% INPUTS
% ------
% info - see "help RPF_info" for information on the contents of the info
%        struct. if following the normal workflow of the RPF toolbox, the
%        info struct used as input here will be the info struct output from 
%        RPF_get_Fx_data 
% data - the data struct output from RPF_get_Fx_data
%
% further optional inputs are
%
% constrain - a struct describing constraints to use in the fit. possible
%             fields are
%   value.alpha  - if specified with value X, the parameter alpha of the fit
%                  is constrained to be X
%   value.beta   - same, but for parameter beta
%   value.gamma  - same, but for parameter gamma
%   value.lambda OR value.omega - same, but for parameter lambda or omega
%
%   alpha, beta, and gamma are parameters controlling threshold, slope, and
%   guess rate, respectively.
%
%   the final parameter, lambda or omega, determines the asymptotic value
%   of the fitted psychometric function. 
%   - lambda is the lapse rate for PFs that fit response probabilities, 
%     including all PFs from the Palamedes toolbox as returned by 
%     RPF_get_PF_list('PFs_lambda') 
%   - omega is the asymptotic maximum value for PFs that fit dependent 
%     variables whose max values can exceed 1, as returned by 
%     RPF_get_PF_list('PFs_omega') 
%
%   additionally, the following special values may be used:
%   - if value.gamma is set to the string 'P_min', then value.gamma will be
%     reset to the value info.P_min
%   - if value.omega is set to the string 'P_max', then value.omega will be
%     reset to the value info.P_max
%
% searchGrid - a struct used to initialize the function fitting process.
%              e.g. see example usage at https://www.palamedestoolbox.org/weibullandfriends.html
%              if unspecified, a default searchGrid is constructed,
%              implementing the constraints in the constrain struct
%
% OUTPUTS
% -------
% fit - a struct array holding details of the function fits. elements of the 
%       struct array are fits for each condition. fields of this struct
%       are as follows:
%   constrain - a copy of the input constrain struct
%   PF        - a copy of info.PF
%   xt_fn     - a copy of info.xt_fn
%   params    - for fitted functions, the psychometric function parameters 
%               [alpha, beta, gamma, lambda]; for interpolation, data and
%               method used for interpolating
%
%   if applicable, additional fields may be
%
%   logL      - log-likelihood of the psychometric function fit
%   SSE       - sum of squared errors of the function fit
%   k         - the number of free parameters in the fit
%   n         - the number of trials used to determine the fit



%% set default values

if ~exist('constrain', 'var')
    constrain = [];
end

if ~exist('searchGrid', 'var')
    searchGrid = [];
end

if isstruct(constrain)
    if isfield(constrain.value, 'gamma') && strcmp(constrain.value.gamma, 'P_min')
        constrain.value.gamma = info.P_min;
    end
    
    if isfield(constrain.value, 'omega') && strcmp(constrain.value.omega, 'P_max')
        constrain.value.omega = info.P_max;
    end
end

%% determine type of fitting to use

switch info.fit_type
    case 'interp'
        fit = RPF_fit_Fx_interp(info, data);

    case 'SSE'
        fit = RPF_fit_Fx_scaled(info, data, constrain, searchGrid);        
  
    otherwise
        switch info.DV
            case {'p(correct)', 'p(response)', 'p(high rating)'}
                fit = RPF_fit_Fx_prob(info, data, constrain, searchGrid);

            case 'd'''
                fit = RPF_fit_Fx_d(info, data, constrain, searchGrid);

            case 'meta-d'''
                fit = RPF_fit_Fx_meta_d(info, data, constrain, searchGrid);        

            case 'mean rating'
                fit = RPF_fit_Fx_meanRating(info, data, constrain, searchGrid);

            case {'type 2 AUC', 'RT'}
                fit = RPF_fit_Fx_scaled(info, data, constrain, searchGrid);        

        end
end
