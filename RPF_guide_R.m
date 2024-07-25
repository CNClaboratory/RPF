% RPF_guide_R
%
% Description of the R struct used in the RPF toolbox. 
%
% The R struct contains information about fits of two psychometric functions 
% P1 = F1(x) and P2 = F2(x), as well as information about the relative 
% psychometric function describing their relationsip, P2 = R(P1). It is
% produced by the function RPF_get_R. For information on how to arrive at the
% R struct, see RPF_guide('workflow').
%
% R contains the following fields:
%
% R.F1 and R.F2
%   - the F structs for P1 = F1(x) and P2 = F2(x), respectively
%   - within R, F1 and F2 have an additional field appended to them, F_ind, 
%     to denote their index, such that F1.F_ind = 1  F2.F_ind = 2 
%   - see RPF_guide('F') for more information
%
% R.INFO STRUCT
% -------------
%
% R.info
%   - analogous to the info struct of the F struct, but with information
%     specific to R
%   - any fields of R.info not described below are copies of values in F1.info 
%     or F2.info for ease of access, and are not discussed further here. refer 
%     to RPF_guide('info') for the definitions of these.
%   - fields of R.info that contain new information are described below
%   - many of these fields pertain to defining the lowest and highest
%     values of P1 that are achievable across all conditions according to
%     the fitted PFs for F1, as these values are used to define the lower
%     and upper bounds for P1 values that are available for computing RPF 
%     AUC across all conditions
%
% R.info.PF_type
%   - a string set to 'R(P1)' to denote that this is an RPF
%
% R.info.PF
%   - a function handle for the psychometric function P2 = R(P1),
%     determined automatically by RPF_get_R
%   - if F1 and F2 are both Weibulls, R.info.PF is set to the Weibull RPF
%     @RPF_Weibull_RPF
%   - if F1 and F2 both use interpolation, R.info.PF is set to the special
%     RPF interpolation function @RPF_interp_RPF
%   - otherwise, R.info.PF is left empty, as R can be evaluated numerically
%     from the information in F1 and F2 without specifying an explicit
%     functional form
%   - see the function RPF_get_PF_list for lists of RPFs organized by
%     various properties
%
% R.info.x_min
%   - the maximal x_min value across F1 and F2, i.e. 
%     R.info.x_min = max( [F1.info.x_min, F2.info.x_min] )
%   - used for the calculation of R.info.P1_LB_min
%
% R.info.x_max
%   - the minimal x_max value across F1 and F2, i.e. 
%     R.info.x_max = min( [F1.info.x_max, F2.info.x_max] )
%   - used for the calculation of R.info.P1_UB_max
%
% R.info.P1_at_x_min(i_cond) and R.info.P2_at_x_min(i_cond)
%   - 1 x nCond arrays holding values of P1 = F1(R.info.x_min) and 
%     P2 = F2(R.info.x_min) at each condition
%   - i.e. measures P1 and P2 at the lowest value of x common to F1 and F2,
%     according to the fitted PFs
%   - P1_at_x_min is used for the calculation of R.info.P1_LB_min
%
% R.info.P1_at_x_max(i_cond) and R.info.P2_at_x_max(i_cond)
%   - 1 x nCond arrays holding values of P1 = F1(R.info.x_max) and 
%     P2 = F2(R.info.x_max) at each condition
%   - i.e. measures P1 and P2 at the highest value of x common to F1 and F2,
%     according to the fitted PFs
%   - P1_at_x_max is used for the calculation of R.info.P1_UB_max
%
% R.info.max_P1_at_x_min
%   - the maximum value of R.info.P1_at_x_min
%   - i.e. measures the maximum across-condition value of P1 at the lowest
%     value of x common to F1 and F2, according to the fitted PFs
%   - used for the calculation of R.info.P1_LB_min
%
% R.info.min_P1_at_x_max
%   - the minimum value of R.info.P1_at_x_max
%   - i.e. measures the minimum across-condition value of P1 at the highest
%     value of x common to F1 and F2, according to the fitted PFs
%   - used for the calculation of R.info.P1_UB_max
%
% R.info.P1_LB_min
%   - the minimum value for the lower bound of the P1 range used to compute
%     RPF AUC across conditions
%   - in most cases, P1_LB_min is set equal to R.info.max_P1_at_x_min
%   - if both F1 and F2 are interpolated, P1_LB_min is set equal to
%     R.info.max_P1_data_min (see "RPF Interpolation" section below)
%
% R.info.P1_UB_max
%   - the maximum value for the upper bound of the P1 range used to compute
%     RPF AUC across conditions
%   - in most cases, P1_UB_max is set equal to R.info.min_P1_at_x_max
%   - if both F1 and F2 are interpolated, P1_UB_max is set equal to
%     R.info.min_P1_data_max (see "RPF Interpolation" section below)
%
% R.info.P1_LB
%   - the actual value of the lower bound of the P1 range used to compute
%     RPF AUC, as used to compute R.fit(i_cond).AUC
%   - can be set as an optional input to RPF_get_R
%   * DEFAULT is R.info.P1_LB_min
%
% R.info.P1_UB
%   - the actual value of the upper bound of the P1 range used to compute
%     RPF AUC, as used to compute R.fit(i_cond).AUC
%   - can be set as an optional input to RPF_get_R
%   * DEFAULT is R.info.P1_UB_max
%
% R.FIT STRUCT
% ------------
% 
% R.fit(i_cond)
%   - analogous to the fit struct of the F struct, but with information
%     specific to R
%
% R.fit(i_cond).P1_at_x_min
%   - value of P1 = F1(R.info.x_min) at condition i_cond
%   - identical to R.info.P1_at_x_min(i_cond)
%
% R.fit(i_cond).P1_at_x_max
%   - value of P1 = F1(R.info.x_max) at condition i_cond
%   - identical to R.info.P1_at_x_max(i_cond)
%
% R.fit(i_cond).PF
%   - a function handle for the psychometric function P2 = R(P1),
%     determined automatically by RPF_get_R
%   - identical to R.info.PF
%
% R.fit(i_cond).params
%   - parameters for the RPF
%   - in most cases, params will contain structs F1 and F2 which store
%     parameters for the fits of F1 and F2, i.e. 
%
%     R.fit(i_cond).params.F1 = F1.fit(i_cond).params;
%     R.fit(i_cond).params.F2 = F2.fit(i_cond).params;
%
%   - if the RPF is being interpolated, then params will contain fields 
%     P1_sorted_unique, P2_sorted_unique, and interp_method (see "RPF
%     Interpolation" section below)
%
% RPF.fit(i_cond).AUC
%   - AUC of the RPF for the current condition over the maximal possible P1 
%     range, i.e.  P1 range = [R.info.P1_LB, R.info.P1_UB]
%   - computed by RPF_AUC
% 
% RPF.fit(i_cond).P2_avg
%   - average P2 value for the current condition over the maximal possible 
%     P1 range, i.e. P1 range = [R.info.P1_LB, R.info.P1_UB]
%   - note that P2_avg = AUC / (P1_UB - P1_LB)
%   - computed by RPF_AUC
%
%
% RPF INTERPOLATION
%
% The fields below apply for the special case where the RPF is being 
% interpolated, i.e. where R.info.PF = @RPF_interp_RPF. To interpolate the
% RPF for P2 vs P1, we must (1) sort P1 in ascending order, and apply the
% same sorting to P2; (2) for any recurring values of P1 in the list,
% remove the duplicates and set the corresponding P2 value to be the
% average of the P2 values across the original set of P1 duplicates. This
% procedure yields the P1_sorted_unique and P2_sorted_unique fields
% discussed below, which are used as "parameters" for the interpolation
% similarly to how the RPF toolbox treat interpolation for F (see
% RPF_guide('fit') section "Interpolation").
% 
% R.info.P1_data_min(i_cond) and R.info.P1_data_max(i_cond)
%   - 1 x nCond arrays holding minimum and maximum values of the P1 data for 
%     each condition
%   - used for the calculation of R.info.P1_LB_min and R.info.P1_UB_max
%
% R.info.max_P1_data_min and R.info.min_P1_data_max
%   - maximum and minimum values of R.info.P1_data_min and R.info.P1_data_max
%   - i.e. max_P1_data_min measures the across-condition maximum of the
%     within-condition minimum values of P1 observed in the data analysis
%   - similarly min_P1_data_max measures the across-condition minimum of
%     the within-condition maximum values of P1 observed in the data analysis
%   - used for the calculation of R.info.P1_LB_min and R.info.P1_UB_max
%
% R.fit(i_cond).params.P1_sorted_unique
%   - a list of sorted unique values of P1 data for this condition
%   - the length of the list may be lower than that of the original list of
%     P1 values in F1.data(i_cond).P due to duplicate P1 values
%
% R.fit(i_cond).params.P2_sorted_unique
%   - a list of sorted unique values of P2 data for this condition
%   - the length of the list may be lower than that of the original list of
%     P2 values in F2.data(i_cond).P due to duplicate P1 values
%   - in case of duplicate P1 values in the original data, duplicates are
%     removed and the corresponding value of P2 is set to the average value
%     of the P2 values across the original set of P1 duplicates
%
% R.fit(i_cond).interp_method
%   - interpolation method, as used by the Matlab function @interp1
%   - identical to F2.fit(i_cond).params.interp_method