function fit = RPF_fit_F(info, data)
% fit = RPF_fit_F(info, data)
%
% Fit data according to the specifications held in info.
%
% INPUTS
% ------
% info - the info struct. see RPF_guide('info') for more
% data - the data struct array. see RPF_guide('data') for more
%
% OUTPUTS
% -------
% fit - a 1 x nCond struct array holding details of the function fits for 
%       each condition. see RPF_guide('fit') for more


%% determine type of fitting to use

switch info.fit_type
    case 'interp'
        fit = RPF_fit_F_interp(info, data);

    case 'SSE'
        fit = RPF_fit_F_scaled(info, data);        
  
    otherwise
        switch info.DV
            case {'p(correct)', 'p(response)', 'p(high rating)'}
                fit = RPF_fit_F_prob(info, data);

            case 'd'''
                fit = RPF_fit_F_d(info, data);

            case 'meta-d'''
                fit = RPF_fit_F_meta_d(info, data);        

            case 'mean rating'
                fit = RPF_fit_F_meanRating(info, data);

            case {'type 2 AUC', 'RT'}
                fit = RPF_fit_F_scaled(info, data);        

        end
end
