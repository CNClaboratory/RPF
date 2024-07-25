function data = RPF_get_Fx_data(info, trialData)
% data = RPF_get_Fx_data(info, trialData)
% 
% INPUTS
% ------
% info - a struct holding settings for data analysis. see RPF_guide('info') 
%    for more information.
% 
% trialData - a struct holding trial-by-trial data from an experiment. see
%    RPF_guide('trialData') for more information.
%
% OUTPUTS
% -------
% data - a struct array with various fields depending on the analysis specified
%        in info.DV. elements of the struct array correspond to different
%        experimental conditions. basic fields common to all analyses are
%
%   x  - a sorted list of all unique x values used in the experiment
%   xt - x after application of the relevant xt_fn function. if there
%        is no x transform, xt == x
%   P  - a summary measure of the DV at each level of x
%
%   other fields contain further data useful for fitting functions to the
%   data and other purposes.


%% get data depending on DV

for i_cond = 1:length(info.cond_vals)

    % get data for current condition
    switch info.DV
        case 'p(response)'
            data(i_cond) = RPF_get_Fx_data_pResponse(info, trialData, i_cond);

        case 'p(correct)'
            data(i_cond) = RPF_get_Fx_data_pCorrect(info, trialData, i_cond);
            
        case 'p(high rating)'
            data(i_cond) = RPF_get_Fx_data_pHighRating(info, trialData, i_cond);
            
        case 'mean rating'
            data(i_cond) = RPF_get_Fx_data_meanRating(info, trialData, i_cond);

        case 'd'''
            data(i_cond) = RPF_get_Fx_data_d(info, trialData, i_cond);

        case 'meta-d'''
            data(i_cond) = RPF_get_Fx_data_meta_d(info, trialData, i_cond);

        case 'type 2 AUC'
            data(i_cond) = RPF_get_Fx_data_type2AUC(info, trialData, i_cond);
            
        case 'RT'
            data(i_cond) = RPF_get_Fx_data_RT(info, trialData, i_cond);
            
    end
end
