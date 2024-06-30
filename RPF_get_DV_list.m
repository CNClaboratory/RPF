function list_out = RPF_get_DV_list(list_type)
% list_out = RPF_get_DV_list(list_type)
% 
% Return all DVs available for analysis in the RPF toolbox according to type.
% 
% INPUTS
% ------
% "list_type" is a string containing the desired DV list. 
% 
% Valid values for "list_type" are listed below. 
% 
% 'DVs_type1'    - all type 1 DVs
% 'DVs_type2'    - all type 2 DVs
% 'DVs_respCond' - all DVs amenable to response-conditional analysis
% 'DVs_prob'     - all DVs that are probabilities
% 'DVs_SDT'      - all DVs pertaining to Signal Detection Theory
% 'DVs_MLE'      - all DVs for which MLE fitting is currently available
% 'DVs_all'      - all DVs available in the RPF toolbox
%
% OUTPUTS
% -------
% "list_out" is the requested list. This is a cell array of strings holding
% function names, not actual function handles.


%% DV lists available

DVs_type1     = {'p(response)', 'p(correct)', 'd''', 'RT'};

DVs_type2     = {'p(high rating)', 'mean rating', 'meta-d''', 'type 2 AUC'};

DVs_respCond  = {'p(correct)', 'RT', 'p(high rating)', 'mean rating', 'meta-d''', 'type 2 AUC'};

DVs_prob      = {'p(response)', 'p(correct)', 'p(high rating)'};

DVs_SDT       = {'d''', 'meta-d''', 'type 2 AUC'};

DVs_MLE       = {'p(response)', 'p(correct)', 'd''', 'p(high rating)', 'mean rating', 'meta-d'''};

DVs_all       = {'p(response)', 'p(correct)', 'd''', 'RT', 'p(high rating)', 'mean rating', 'meta-d''', 'type 2 AUC'};


%% package output

list_out = eval( list_type );