function list_out = RPF_get_PF_list(list_type)
% list_out = RPF_get_PF_list(list_type)
% 
% Return all PF functions natively available in the RPF toolbox according
% to type.
% 
% INPUTS
% ------
% "list_type" is a string containing the desired PF list. 
% 
% Valid values for "list_type" are listed below. Note that in the below, 
% 'PF' refers to psychometric functions applied to F(x) and 'RPF' refers to 
% relative psychometric functions applied to R(P1).
% 
% 'PFs_log'       - all PFs that assume a log-transformed x-axis
% 'PFs_scaled'    - all PFs that allow for an arbitrary maximum value
% 'PFs_Palamedes' - all PFs adopted from the Palamedes toolbox
% 'PFs_special'   - all PFs designed for use with special cases (currently,
%                   for use with PF interpolation and fitting mean rating)
% 'PFs_all'       - all PFs
% 'RPFs_special'  - all RPFs designed for use with special cases (currently,
%                   for use with RPF interpolation
% 'RPFs_all'      - all RPFs
%
% OUTPUTS
% -------
% "list_out" is the requested list. This is a cell array of strings holding
% function names, not actual function handles.


%% PF lists available

% PFs
PFs_log       = {'PAL_Logistic', 'PAL_Gumbel', 'PAL_logQuick', 'PAL_CumulativeNormal', ...
                 'PAL_HyperbolicSecant', 'RPF_scaled_Gumbel', 'RPF_scaled_logQuick'};
            
PFs_scaled    = {'RPF_scaled_Weibull', 'RPF_scaled_Gumbel', 'RPF_scaled_Quick', 'RPF_scaled_logQuick'};

PFs_Palamedes = {'PAL_Weibull', 'PAL_Gumbel', 'PAL_Quick', 'PAL_logQuick', 'PAL_Logistic', ...
                 'PAL_CumulativeNormal', 'PAL_HyperbolicSecant'};

PFs_inverse   = {'PAL_Weibull', 'PAL_Gumbel', 'PAL_Quick', 'PAL_logQuick', 'PAL_Logistic', ...
                 'PAL_CumulativeNormal', 'PAL_HyperbolicSecant'};
             
PFs_special   = {'RPF_meanRating_PF', 'RPF_interp_Fx'};

PFs_all       = unique( [PFs_log, PFs_scaled, PFs_Palamedes, PFs_inverse, PFs_special] );


% RPFs
RPFs_special  = {'RPF_interp_RPF'};

RPFs_analytic = {'RPF_Weibull_RPF'};

RPFs_all      = unique( [RPFs_special, RPFs_analytic] );


%% package output

list_out = eval( list_type );