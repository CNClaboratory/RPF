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
%   value.lambda - same, but for parameter lambda
%
%   if the fitted PF is one of the scaled PFs (see help RPF_info for more),
%   then instead of value.lambda the final parameter will be value.omega,
%   which sets the maximum possible value of the psychometric function
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
