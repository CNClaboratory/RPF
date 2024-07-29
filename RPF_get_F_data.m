function data = RPF_get_F_data(info, trialData)
% data = RPF_get_F_data(info, trialData)
% 
% INPUTS
% ------
% info - a struct holding settings for data analysis. see RPF_guide('info')
% 
% trialData - a struct holding trial-by-trial data from an experiment. see
%    RPF_guide('trialData')
%
% OUTPUTS
% -------
% data - a struct array hold results of the data analysis. see RPF_guide('data')


%% get data depending on DV

for i_cond = 1:length(info.cond_vals)

    % get data for current condition
    switch info.DV
        case 'p(response)'
            data(i_cond) = RPF_get_F_data_pResponse(info, trialData, i_cond);

        case 'p(correct)'
            data(i_cond) = RPF_get_F_data_pCorrect(info, trialData, i_cond);
            
        case 'p(high rating)'
            data(i_cond) = RPF_get_F_data_pHighRating(info, trialData, i_cond);
            
        case 'mean rating'
            data(i_cond) = RPF_get_F_data_meanRating(info, trialData, i_cond);

        case 'd'''
            data(i_cond) = RPF_get_F_data_d(info, trialData, i_cond);

        case 'meta-d'''
            data(i_cond) = RPF_get_F_data_meta_d(info, trialData, i_cond);

        case 'type 2 AUC'
            data(i_cond) = RPF_get_F_data_type2AUC(info, trialData, i_cond);
            
        case 'RT'
            data(i_cond) = RPF_get_F_data_RT(info, trialData, i_cond);
            
    end
end
