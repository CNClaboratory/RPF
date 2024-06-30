% RPF_info
%
% Description of the fields of the info struct used in the RPF toolbox. 
% 
% Most fields have sensible default values that are set in the function 
% RPF_update_Fx_info. The only field with no default value that must be 
% defined manually is info.DV .
% 
% GENERAL FIELDS AND SETTINGS
% 
% info.PF_type 
%   - a string describing whether this is an ordinary or relative PF
%   - note that in most use cases, the user will only need to manually
%   define the info struct for F(x), with the info struct for R being
%   determined automatically by RPF_get_R
%
%   values
%   - 'F(x)' --> ordinary PF of the form P = F(x) where P is performance and
%     x is stimulus strength.
%   - 'R(P1)' --> relative PF of the form P2 = R(P1) where P1 and P2 are
%     different performance variables
%   * DEFAULT = 'F(x)'
%
% info.DV 
%   - a string denoting the dependent variable for P = F(x)
%   - see the function RPF_get_DV_list for lists of DVs organized by
%     various properties
% 
%   values
%   - 'p(response)'  [probability that trialData.response == 1]
%   - 'p(correct)'
%   - 'p(high rating)'
%   - 'mean rating'
%   - 'd'''
%   - 'meta-d'''
%   - 'type 2 AUC'
%   - 'RT'
%   * NO DEFAULT - must be defined manually
%
% info.PF
%   - a function handle for the psychometric function F(x) to be fitted
%   - see the function RPF_get_PF_list for lists of PFs organized by
%     various properties
%
%  values
%  - any psychometric functions from the Palamedes toolbox: 
%    @PAL_Weibull, @PAL_Gumbel, @PAL_Quick, @PAL_logQuick, @PAL_Logistic,
%    @PAL_CumulativeNormal, @PAL_HyperbolicSecant
%  - any "scaled" version of these psychometric functions available in the
%    RPF toolbox, which allow for PFs with an arbitrary maximum value:
%    @RPF_scaled_Weibull, @RPF_scaled_Gumbel, @RPF_scaled_Quick, 
%    @RPF_scaled_logQuick
%  - special case for fitting mean rating: @RPF_meanRating_PF
%  - special case for interpolation: @RPF_interp_Fx
%  * DEFAULT is set to
%      - @RPF_interp_Fx if info.fit_type is 'interp'
%      - @PAL_Weibull if info.DV is a probability
%      - @RPF_meanRating_PF if info.DV is 'mean rating' and info.fit_type
%        is 'MLE' (see "Fitting mean rating" below)
%      - @RPF_scaled_Weibull for all other cases
%
%  usage
%  - if fitting p(response), p(correct), or p(high rating), use one of the
%    Palamdes toolbox functions as returned by RPF_get_PF_list('PFs_Palamedes')
%  - if fitting d', meta-d', type 2 AUC, or RT, or if fitting mean rating 
%    via SSE, use one of the scaled psychometric functions as returned by 
%    RPF_get_PF_list('PFs_scaled')
%  - if fitting mean rating via MLE, use @RPF_meanRating_PF
%  - if interpolating, use @RPF_interp_Fx
%
% info.fit_type
%   - describes the type of fitting to be conducted, i.e. maximizing
%     likelhood, minimizing sum of squared errors, or interpolating
%   - for type 2 AUC and RT, MLE fitting is not currently available. these
%     DVs can be fitted by minimizing SSE or interpolated.
%
%   values
%   - 'MLE'    ~ maximum likelihood estimation
%   - 'interp' ~ interpolation
%   - 'SSE'    ~ minimize sum of squared errors
%   * DEFAULT value depends on info.PF:
%     - info.PF is 'RPF_interp_Fx' --> default is 'interp'
%     - info.PF is 'type 2 AUC' or 'RT' --> default is 'SSE'
%     - all other values of info.PF --> default is 'MLE'
%
% info.x_vals
%   - a vector of the unique values for stimulus strength x (PRIOR TO any 
%     transforms such as e.g. a log10 transform) for which the dependent 
%     variable info.DV is defined. must be sorted in ascending order
%   - these x values correspond to the values of the dependent variable at
%     each level of stimulus strength as stored in F.data(i_cond).P. note that 
%     for dependent variables that are undefined at x = 0 (e.g. p(correct)
%     for grating tilt discrimination when grating contrast = 0),
%     info.x_vals should omit x = 0 so that the length of info.x_vals
%     matches the length of F.data(i_cond).P
%   - NOTE: x values should be on a scale such that the value x = 0
%     corresponds to the minimal possible stimulus strength, at which the
%     subject achieves chance rates of psychometric performance, since this 
%     behavior is assumed by the psychometric functions available here, such 
%     as the Weibull. if your x data do not have x = 0 as this minimum value 
%     correspoding to chance-level performace, you should transform your x 
%     values PRIOR TO entry to the RPF toolbox, so that psychometric
%     function fits on untransformed x values will yield chance-level 
%     responding at x = 0 as intended. for instance, if your x data are in 
%     the form of a ratio with 1 as the minimum value, consider a transformation 
%     that converts x = 1 to x = 0, e.g. log10(x). note that this transformation 
%     would be applied PRIOR TO any subsequent transformations of x managed 
%     by the RPF toolbox using info.xt_fn (see below)
%   * DEFAULT depends on info.DV
%     - if info.DV depends on measuring accuracy ('p(correct)', 'd''', 'meta-d''', 
%       or 'type 2 AUC') then info.x_vals defaults to unique values of 
%       trialData.x for which trialData.stimID ~= 0.5, which is the value of 
%       stimID used to indicate an undefined stimulus ID (e.g. grating tilt is 
%       undefined when grating contrast = 0)
%     - otherwise, info.x_vals defaults to all unique values of trialData.x
%     - Inf and Nan values of trialData.x are automatically removed in this
%       calculation
%
% info.x_min and info.x_max
%   - minimum and maximum values for stimulus strength x, PRIOR TO any 
%     transforms such as e.g. a log10 transform
%   - these values are used to define the default lower and upper bounds
%     for the RPF P2 = R(P1) over which AUC can be computed for all conditions, 
%     where the lower bound of P1 is defined as the maximum across-condition 
%     value of P1 at x_min, and the upper bound of P1 is defined as the 
%     minmum across-condition value of P1 at x_max. these values are stored 
%     in R.info.max_P1_at_x_min and R.info.min_P1_at_x_max, respectively, 
%     in the R struct returned by RPF_get_R. 
%   - info.x_min and info.x_max are also used to define the default lower
%     and upper bounds of the plots of F1(x) and F2(x) in RPF_plot
%   - setting info.x_min to a value greater than min(info.x_vals) and 
%     info.x_max to a value less than max(info.x_vals) allows for specifying 
%     a narrow analysis range within the range of info.x_vals. conversely, 
%     setting info.x_min to a value less than min(info.x_vals) and
%     info.x_max to a value greater than max(info.x_vals) allows for
%     extrapolation of a psychometric function fit beyond the range of
%     info.x_vals to enter into the RPF analysis.
%   * DEFAULT is the min and max values of trialData.x containing valid
%     values for trialData.stimID (= 0, 1, or 0.5) after removing any Inf 
%     and Nan values
%   * RECOMMENDED setting is to set x_min and x_max to the min and max
%     values possible for the stimulus (e.g. for contrast, x_min = 0 and
%     x_max = 1), provided that the values in info.x_vals are not too far
%     from these extremes. this allows AUC analysis and plotting over the
%     broadest range possible. however, note that for interpolation, x_min
%     and x_max should not exceed min(x_vals) and max(x_vals). 
%
% info.xt_fn
%   - a function handle determining any transform applied to x for use with
%     info.PF, e.g. @log10 for a log transform.
%   * DEFAULT determined from info.PF by the function RPF_get_PF_xt_fn.
%     for any PF that assumes a log10 x-axis, the default for
%     info.xt_fn is @log10. for all other functions, the default for 
%     xt_fn is @(x)(x), i.e. the identity function. PFs that assume a
%     log10 x-axis are 'PAL_Logistic', 'PAL_Gumbel', 'PAL_logQuick', 
%     'PAL_CumulativeNormal', 'PAL_HyperbolicSecant', 'RPF_scaled_Gumbel', 
%     and 'RPF_scaled_logQuick'
%
% info.xt_fn_inv
%   - a function handle for the inverse of info.xt_fn, e.g. @(x)(10.^x)
%     for the inverse of @log10.
%   * DEFAULT determined from info.PF by the function RPF_get_PF_xt_fn.
%     for PFs assuming a log10 x-axis, xt_fn_inv defaults to
%     @(x)(10.^x). for all other functions, xt_fn_inv defaults to 
%     @(x)(x), i.e. the identity function.
% 
% info.xt_vals, info.xt_min, info.xt_max
%   - unique values, min, and max for x AFTER having been transformed as
%     specified in info.xt_fn
%   * DEFAULT determined from applying info.xt_fn to info.x_vals, 
%     info.x_min, and info.x_max
%
% info.x_label
%   - a string providing a label for x, e.g. 'contrast'
%   - used by RPF_plot for the default label of the stimulus strength axis
%   - can also add clarity when working with variables in Matlab
%   * DEFAULT is 'x'
%
% info.P_min and info.P_max
%   - minimum and maximum values for performance P = F(x)
%   - used by the RPF toolbox in the following circumstances
%     - to optionally append (x_min, P_min) and/or (x_max, P_max) to the
%       data for use with interpolation
%     - to define the initial searchGrid for fitting scaled PFs in the
%       function RPF_default_searchGrid_scaled
%     - to set the lower and upper bounds for the omega parameter of scaled
%       PFs (which sets the PF's asymptotic value)
%     - to define AUC_max and AUC_rel in the function RPF_AUC
%     - to define default plotting options in the function RPF_plot
%   * DEFAULT values depend on info.DV:
%     - 'p(response)'    ~ [0, 1]
%     - 'p(correct)'     ~ [0.5, 1]
%     - 'p(high rating)' ~ [0, 1]
%     - 'mean rating'    ~ [1, info.nRatings]
%     - 'd'''            ~ [0, 5]
%     - 'meta-d'''       ~ [0, 5]
%     - 'type 2 AUC'     ~ [0.5, 1]
%     - 'RT'             ~ [0, max(trialData.RT)]
%
% info.P_label
%   - a string providing a label for P, e.g. 'p(high rating | r="S2")'
%   - used by RPF_plot for the default label of the performance axes
%   - can also add clarity when working with variables in Matlab
%   * DEFAULT is info.DV, with added text ' for resp="S1"' or ' for resp =
%     "S2"' for relevant DVs if info.DV_respCond is 'rS1' or 'rS2'
%
% info.cond_vals
%   - numerical vector of the condition label values, if any
%   * DEFAULT determined from trialData.condition. If there are no
%     conditions, default value is 0.
% 
% info.nCond
%   - number of conditions, i.e. length(info.cond_vals)
%   * DEFAULT determined from info.cond_vals
%
% info.cond_labels
%   - 1 x nCond cell array containing strings that label each condition
%     (e.g. {'attended', 'unattended'})
%   - used by RPF_plot for the default legend setting
%   - can also add clarity when working with variables in Matlab
%   * DEFAULT is 'cond = C' for all values of C in info.cond_vals
% 
% info.nRatings
%   - number of ratings in the rating scale (e.g. for confidence,
%     awareness, etc.)
%   * DEFAULT determined from trialData.rating. If there are no ratings,
%     default value is 1.
%
% 
% FIELDS AND SETTINGS FOR SPECIFIC USE CASES
%
% -------------
% Interpolation
% -------------
% info.PF
%   - must be set to @RPF_interp_Fx
%
% info.interp_method
%   - interpolation method, as used by the Matlab function @interp1
%   * DEFAULT value is 'linear'
%
% info.append_xP_min
%   - boolean controlling whether to append (info.x_min, info.P_min) to the
%     list of data points used for interpolation
%   - if your data set includes presentations of stimuli where x == info.x_min
%     but stimID is undefined (e.g. as in a spatial 2AFC discrimination
%     task where contrast = 0), then it is possible that one of the functions 
%     in your RPF analysis will be undefined at x_min and other will have a 
%     defined value. DVs that measure or depend on accuracy are undefined 
%     when stimID is undefined, included 'p(correct)', 'd''', 'meta-d''',
%     and 'type 2 AUC'. DVs that do not measure or depend on accuracy can
%     still be defined when stimID is undefined, including 'p(response)', 
%     'p(high rating)', 'mean rating', and 'RT'. if your RPF analysis uses
%     one DV of each type, and if you want to estimate RPC AUC using
%     interpolation over both F1 and F2, then you should set
%     info.append_xP_min = 1 for the DV that is undefined at x_min (e.g.
%     'p(correct)') so that the number of data points used in the RPF
%     interpolation over F1 and F2 is equal.
%   * DEFAULT value is 0
% 
% info.append_xP_max
%   - boolean controlling whether to append (info.x_max, info.P_max) to the
%     list of data points used for interpolation
%   * DEFAULT value is 0
%
% info.x_min and info.x_max
%   - note that if info.x_min is defined manually but is below the minimum 
%     value found in trialData.x, and if info.append_xP_min == 0, then 
%     info.x_min will be automatically reset to the min value found in
%     trialData.x for consistency with the interpolation approach
%   - similar considerations hold for info.x_max
%
%
% ---------------------------------------
% Response condition for type 2 variables
% ---------------------------------------
% These considerations hold if info.DV is any of the following type 2 variables:
% 'p(high rating)', 'mean rating', 'type 2 AUC', 'meta-d'''
%
% Additionally, response-specific analysis can also be conducted for the
% following non-type-2 variables in info.DV:
% 'p(correct)', 'RT'
%
% info.DV_respCond
%   - determines which response types should be used for the type 2
%     variable, i.e. whether we should restrict the analysis to "S1" or
%     "S2" responses, or include all responses
%
%   values
%   - 'rS1' ~ conduct a response-specific analysis for "S1" responses
%   - 'rS2' ~ conduct a response-specific analysis for "S2" responses
%   - 'all' ~ do not conduct a response-specific analysis, use all responses
%   * DEFAULT value is 'all'
% 
% 
% ----------------------------
% Threshold for p(high rating)
% ----------------------------
% info.DV_thresh
%   - threshold rating value used to define high ratings, i.e. 
%     p(high rating) = p(rating >= info.DV_thresh)
% 
%   values
%   - as the rating scale is defined to range from 1 to info.nRatings, any 
%     integer value from 2 to info.nRatings is valid
%   * DEFAULT value is threshold determined from median split (see below)
%
% info.DV_thresh_type
%   - if set to the string 'median split', then info.DV_thresh is chosen so 
%     as to best balance the trial counts for "low" and "high" ratings 
%     across all trials and conditions in trialData. this is calculated in 
%     the function RPF_get_thresh_for_med_split
%   * DEFAULT value is 'median split' if info.DV_thresh is not specified,
%     and 'pre-specified' otherwise
%
% 
% -------------------
% Fitting mean rating
% -------------------
% info.PF
%   - for MLE fitting, info.PF must be set to @RPF_meanRating_PF
%   - for SSE fitting, info.PF can be any of the scaled PFs, i.e. 
%     @RPF_scaled_Weibull, @RPF_scaled_Gumbel, @RPF_scaled_Quick, 
%     @RPF_scaled_logQuick
% 
% info.PF_pHighRating
%   - this is an additional PF function handle determining which PF is used
%     to fit the component PFs p(rating >= 2), p(rating >= 3), ...,
%     p(rating >= info.nRatings) using MLE. these component PFs are used to 
%     construct the mean rating PF.
%   - this field is only applicable for MLE fitting of mean rating. it does
%     not need to be specified for SSE fitting.
%
% ----------------------
% Fitting d' and meta-d'
% ----------------------
% info.padCells
%   - boolean controlling whether response count cells nR_S1 and nR_S2 are 
%     padded to prevent 0s from interfering with the analysis results
%   * DEFAULT is 0, but recommended value is 1 if any cells in nR_S1 or 
%     nR_S2 for any subject in the analysis are 0
%
% info.padAmount
%   - amount to add to every cell of nR_S1 and nR_S2 if info.padCells == 1
%   * DEFAULT is 1 / (2*info.nRatings)
%
% info.padCells_nonzero_d
%   - boolean controlling whether response count cells nR_S1 and nR_S2 are
%     padded to prevent a value of d' = 0 from interfering with meta-d'
%     analysis (meta-d' is undefined when d' = 0 since fitting meta-d'
%     requires using c' = c/d')
%   * DEFAULT is 0, but recommended value is 1 if any conditions in the
%     data to be fitted yield d' = 0
% 
% info.padAmount_nonzero_d
%   - amount to add to nR_S1(1:nRatings) and nR_S2(nRatings+1:end) if
%     info.padCells_nonzero_d == 1
%   * DEFAULT is 1e-5
% 
% info.PF
%   - this should be set to one of the "scaled" PFs, i.e.
%    @RPF_scaled_Weibull, @RPF_scaled_Gumbel, @RPF_scaled_Quick, 
%    @RPF_scaled_logQuick
%
% info.P_min
%   - recommended value = 0
%
% info.P_max
%   - for d', if info.padCells == 1, the recommended value of info.P_max is 
%     max( [data.d_pad_max] ) where data is returned from RPF_get_Fx_data. 
%     this defines the max value of the fitted PF to be the max d' value 
%     achievable given the cell padding settings and trial counts.
%   - for meta-d', or for d' if info.padCells == 0, the recommended value 
%     of info.P_max is a large signal-to-noise ratio value, such as 5. 
%     adjust as needed for your data and use case.