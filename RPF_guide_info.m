% RPF_guide_info
%
% Description of the info struct used in the RPF toolbox. 
%
% Note that this refers to the info struct of the F struct. For information
% about the info struct of the R struct, see RPF_guide('R').
% 
% info is a struct whose fields contain information and settings that are 
% used to determine how data analysis and psychometric function fitting
% should proceed in the functions RPF_get_F_data and RPF_fit_F_data. Some 
% information in info is also used to help guide subsequent RPF analysis. 
%
% info can contain the fields listed below. Many of these fields are
% required for all analyses, and some are specific to certain use cases
% (e.g. doing signal detection theory analysis). See the section "FIELDS 
% AND SETTINGS FOR SPECIFIC USE CASES" below for more on that.
%
% Most fields have sensible default values, such that you only need to 
% specify a handful of fields that are unique to your use case, and allow 
% the rest to take on their default values. The only field with no default 
% value that must be defined manually is info.DV.
%
% After manually defining your fields of interest, you can use the function 
% RPF_update_info to set the rest of the fields to their defaults. This
% function also requires you to pass in trialData as an input (see
% RPF_guide('trialData')). Note that if you use the normal RPF toolbox
% workflow and pass info as an input to RPF_get_F (e.g. as illustrated in 
% RPF_example_simple), then your manually defined info struct is
% automatically updated with RPF_update_info inside RPF_get_F.
%
% GENERAL FIELDS AND SETTINGS
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
% info.PF_type 
%   - a string describing whether this is an ordinary or relative PF
%   - note that in most use cases, the user will only need to manually
%     define the info struct for F(x), with the info struct for R being
%     determined automatically by RPF_get_R
%
%   values
%   - 'F(x)' --> ordinary PF of the form P = F(x) where P is performance and
%     x is stimulus strength.
%   - 'R(P1)' --> relative PF of the form P2 = R(P1) where P1 and P2 are
%     different performance variables
%   * DEFAULT = 'F(x)'
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
%  - special case for interpolation: @RPF_interp_PF
%  - use RPF_get_PF_list to get listings of PFs available in the RPF toolbox 
%    organized by various characteristics
%  * DEFAULT is set to
%      - @RPF_interp_PF if info.fit_type is 'interp'
%      - @PAL_Weibull if info.DV is a probability
%      - @RPF_meanRating_PF if info.DV is 'mean rating' and info.fit_type
%        is 'MLE' (see "Fitting mean rating" below)
%      - @RPF_scaled_Weibull for all other cases
%
%  usage
%  - if fitting p(response), p(correct), or p(high rating), use one of the
%    PFs for fitting response probabilities, as returned by 
%    RPF_get_PF_list('PFs_respProb')
%  - if fitting d', meta-d', type 2 AUC, or RT, or if fitting mean rating 
%    via SSE, use one of the scaled PFs as returned by 
%    RPF_get_PF_list('PFs_scaled')
%  - if fitting mean rating via MLE, use @RPF_meanRating_PF
%  - if interpolating, use @RPF_interp_PF
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
%     - info.PF is 'RPF_interp_PF'      --> default is 'interp'
%     - info.PF is 'type 2 AUC' or 'RT' --> default is 'SSE'
%     - all other values of info.PF     --> default is 'MLE'
%
% info.x_vals
%   - a vector of the unique values for stimulus strength x. these must be 
%     sorted in ascending order
%   - these x values correspond to the values of the dependent variable at
%     each level of stimulus strength as stored in F.data(i_cond).P. note that 
%     for dependent variables that are undefined at x = 0 (e.g. p(correct)
%     for grating tilt discrimination when grating contrast = 0),
%     info.x_vals should omit x = 0 so that the length of info.x_vals
%     matches the length of F.data(i_cond).P
%   - see RPF_guide('trialData') for more information on how x values
%     should be defined in the RPF toolbox
%   * DEFAULT depends on info.DV
%     - if info.DV depends on measuring accuracy ('p(correct)', 'd''', 'meta-d''', 
%       or 'type 2 AUC') then info.x_vals defaults to unique values of 
%       trialData.x for which trialData.stimID ~= 0.5, which is the value of 
%       stimID used to indicate an undefined stimulus ID (e.g. grating tilt is 
%       undefined when grating contrast = 0). see RPF_guide('trialData')
%       for further discussion
%     - otherwise, info.x_vals defaults to all unique values of trialData.x
%       after removal of any Inf and Nan values
%
% info.x_min and info.x_max
%   - minimum and maximum values for stimulus strength x
%   - these values are used to define the default lower and upper bounds
%     for the RPF P2 = R(P1) over which AUC can be computed for all conditions, 
%     where the default lower bound of P1 is defined as the maximum across-
%     condition value of P1 at x_min, and the default upper bound of P1 is 
%     defined as the minimum across-condition value of P1 at x_max. these 
%     values are stored in R.info.max_P1_at_x_min and R.info.min_P1_at_x_max, 
%     respectively, in the R struct returned by RPF_get_R. 
%   - info.x_min and info.x_max are also used to define the default lower
%     and upper bounds of the plots of F1(x) and F2(x) in RPF_plot
%   - setting info.x_min to a value greater than min(info.x_vals) and 
%     info.x_max to a value less than max(info.x_vals) allows for specifying 
%     a narrow analysis range within the range of info.x_vals. conversely, 
%     setting info.x_min to a value less than min(info.x_vals) and
%     info.x_max to a value greater than max(info.x_vals) allows for
%     extrapolation of a psychometric function fit beyond the range of
%     info.x_vals to enter into the RPF analysis.
%   - see RPF_guide('trialData') for more information on how x values
%     should be defined in the RPF toolbox
%   * DEFAULT is the min and max values of trialData.x containing valid
%     values for trialData.stimID (= 0, 1, or 0.5) after removing any Inf 
%     and Nan values
%   * RECOMMENDED setting is to set x_min and x_max to the min and max
%     values possible for the stimulus (e.g. for contrast, x_min = 0 and
%     x_max = 1), provided that the values in info.x_vals are not too far
%     from these extremes. this allows AUC analysis and plotting over the
%     broadest range possible. 
%
%     however, note that for interpolation, x_min and x_max should not 
%     exceed min(x_vals) and max(x_vals), since interpolation cannot 
%     extrapolate beyond observed data (but see the "Interpolation" section 
%     below for optional appending of interpolation data corresponding to 
%     known minimum and/or maximum (x, P) pairs).
%
% info.xt_fn
%   - a function handle determining any transform applied to x for use with
%     info.PF, e.g. @log10 for a log transform.
%   - if no transform for x is needed, set xt_fn = @(x)(x), i.e. the
%     identity function.
%   * DEFAULT determined from info.PF using the function RPF_get_PF_xt_fn.
%     for any PF that assumes a log10 x-axis, the default for
%     info.xt_fn is @log10. for all other functions, the default for 
%     xt_fn is @(x)(x). PFs that assume a log10 x-axis can be listed via 
%     RPF_get_PF_list('PFs_log').
%
% info.xt_fn_inv
%   - a function handle for the inverse of info.xt_fn, e.g. @(x)(10.^x)
%     for the inverse of @log10.
%   * DEFAULT determined from info.PF using the function RPF_get_PF_xt_fn.
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
%       data for use with interpolation (see "Interpolation" section below)
%     - to define the initial searchGrid for fitting scaled PFs in the
%       function RPF_default_searchGrid
%     - to set the lower and upper bounds for the omega parameter of scaled
%       PFs (which sets the PF's asymptotic value)
%     - to define default plotting settings in the function RPF_plot
%   * DEFAULT values depend on info.DV:
%     - 'p(response)'    ~ [0, 1]
%     - 'p(correct)'     ~ [0.5, 1]
%     - 'p(high rating)' ~ [0, 1]
%     - 'mean rating'    ~ [1, info.nRatings]
%     - 'd'''            ~ depends on settings (see below)
%     - 'meta-d'''       ~ depends on settings (see below)
%     - 'type 2 AUC'     ~ [0.5, 1]
%     - 'RT'             ~ [0, max(trialData.RT)]
%   - for d' and meta-d', the default values of info.P_min and info.P_max 
%     depend on cell padding settings. see "Fitting d' and meta-d'" section 
%     below for more details.
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
%   - see RPF_guide('trialData') for more information on how condition values
%     should be defined in the RPF toolbox
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
%   - see RPF_guide('trialData') for more information on how rating values
%     should be defined in the RPF toolbox
%   * DEFAULT determined from trialData.rating. If there are no ratings,
%     default value is 1.
%
% info.constrain
%   - struct specifying constraints (if any) to place on PF parameters when
%     fitting the PF to the data
%   - see RPF_guide('constrain') for more information
%   * DEFAULT is []
%
% info.paramsFree
%   - 1 x 4 array indicating whether the alpha, beta, gamma, lambda/omega
%     parameters of the PF are free or fixed, where 1 means free and 0
%     means fixed
%   - e.g. paramsFree = [1 1 0 1] would indicate that gamma is fixed but
%     all other parameters are free
%
% info.searchGrid
%   - struct specifying the searchGrid used to initialize parameter
%     estimates for the PF fitting algorithm
%   - see RPF_guide('searchGrid') for more information
% 
% FIELDS AND SETTINGS FOR SPECIFIC USE CASES
%
% -------------
% Interpolation
% -------------
% info.PF
%   - must be set to @RPF_interp_PF
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
%     in your RPF analysis will be undefined at x_min and the other will have 
%     a defined value. DVs that measure or depend on accuracy are undefined 
%     when stimID is undefined, including 'p(correct)', 'd''', 'meta-d''',
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
% --------------------------
% Response-specific analysis
% --------------------------
% It may be of interest to limit the analysis to trials where a specific
% type 1 response was given. For instance, in a detection task where "S2" 
% responses indicate detection of the target stimulus, it may be of interest 
% to analyze p(high rating) only for trials where the subject detected the 
% stimulus, i.e. only for trials where the subject responded "S2". 
%
% Response-specific analysis can be conducted in the following cases, by 
% setting the appropriate value for info.DV_respCond:
% - if info.DV is any of the following type 2 variables:
%   'p(high rating)', 'mean rating', 'type 2 AUC', 'meta-d'''
% - if info.DV is any of the following non-type-2 variables:
%   'p(correct)', 'RT'
%
% info.DV_respCond
%   - determines which response types should be used for the data analysis, 
%     i.e. whether we should restrict the analysis to "S1" or "S2" responses, 
%     or include all responses
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
% For rating scales with more than two options, there are more than one way
% to binarize the rating scale into "low" and "high" ratings which can then
% be used to compute p(high rating). The cutoff for what is considered to
% be a "high" rating is specified in info.DV_thresh.
%
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
%   - otherwise, info.DV_thresh_type is ignored and info.DV_thresh is
%     assumed to have been manually specified
%   * DEFAULT value is 'median split' if info.DV_thresh is not specified,
%     and 'pre-specified' otherwise
%
% 
% -------------------
% Fitting mean rating
% -------------------
% Fitting mean rating using MLE requires specification of a special
% psychometric function that separately conducts MLE fits of PFs for 
% p(rating >= thresh) for all values of thresh in [2, nRatings] and then
% combines these.
%
% info.PF
%   - for MLE fitting, info.PF must be set to @RPF_meanRating_PF
%   - for SSE fitting, info.PF can be any of the scaled PFs as returned by
%     RPF_get_PF_list('PFs_scaled')
% 
% info.PF_pHighRating
%   - this is an additional PF function handle determining which PF is used
%     to fit the component PFs p(rating >= 2), p(rating >= 3), ...,
%     p(rating >= info.nRatings) using MLE. these component PFs are used to 
%     construct the mean rating PF.
%   - this should be one of the PFs returned by RPF_get_PF_list('PFs_respProb')
%   - this field is only applicable for MLE fitting of mean rating. it does
%     not need to be specified for SSE fitting.
%
% ----------------------
% Fitting d' and meta-d'
% ----------------------
% In signal detection theory analyses of d' and meta-d', it is common for
% raw data to pose problems for the analysis. For instance, d' is infinite
% if hit rate = 1 or false alarm rate = 0, and meta-d' is undefined if any
% cells of the response count variables nR_S1 and nR_S2 are zero, or if d'
% = 0. (For more on nR_S1 and nR_S2, see RPF_guide('counts').) These issues 
% can be circumvented by introducing a small degree of "cell padding" to 
% prevent numerical issues while minimally affecting the results of the data 
% analysis.
%
% This cell padding approach is a generalization of the correction for 
% estimation issues of type 1 d' recommended in
% 
% Hautus, M. J. (1995). Corrections for extreme proportions and their biasing 
%     effects on estimated values of d'. Behavior Research Methods, Instruments, 
%     & Computers, 27, 46-51.
%     
% When using this correction method, it is recommended to use the same cell 
% padding for all data of all subjects, even for those subjects whose data is 
% not in need of such correction, in order to avoid biases in the analysis 
% (cf Snodgrass & Corwin, 1988).
%
% Many of the cell padding settings for working with d' and meta-d' listed 
% below default to being turned off to ensure that if these settings are 
% used, the user is explicitly aware of that fact. Nonetheless, for most use 
% cases it is likely that at least some data for at least some subjects 
% require cell padding to prevent numerical issues in SDT analysis. Therefore, 
% as a quick summary, it is recommended to specify the following settings 
% when analyzing d' or meta-d' in the RPF toolbox:
%
% info.padCells                       = 1;
% info.padCells_correctForTrialCounts = 1;
% info.padCells_nonzero_d             = 1;
% info.set_P_min_to_d_pad_min         = 1;
% info.set_P_max_to_d_pad_max         = 1;
%
% Alternatively, a shorthand option is to set info.useAllPaddingSettings =
% 1 (see below).
% 
% A more detailed consideration of individual settings is included below.
%
% info.padInfo
%   - a 1 x nCond struct array containing information on the cell padding
%     settings which will be used in each condition
%   - automatically generated when info.DV is d', meta-d', or type 2 AUC
%   - see RPF_guide('padInfo') for more details
% 
% info.useAllPaddingSettings
%   - a boolean controlling whether to default all padding settings to be
%     turned on. if set to 1, it sets all of the following fields to 1,
%     overwriting any values that may have been manually specified:
%     - info.padCells
%     - info.padCells_correctForTrialCounts
%     - info.padCells_nonzero_d
%     - info.set_P_min_to_d_pad_min
%     - info.set_P_max_to_d_pad_max
%   * DEFAULT is 0
% 
% info.padCells
%   - boolean controlling whether response count cells nR_S1 and nR_S2 are 
%     padded to prevent 0s from interfering with the analysis results
%   * DEFAULT is 0, but recommended value is 1 for ALL subjects if numerical 
%     issues in the SDT analysis arise for ANY subject
%
% info.padAmount
%   - amount to add to every cell of nR_S1 and nR_S2 if info.padCells == 1
%   - but see info.padCells_correctForTrialCounts for a possible modification
%   * DEFAULT is 1 / (2*info.nRatings)
%   
% info.padCells_correctForTrialCounts
%   - if set to 1, corrects for imbalances in trial counts for S1 and S2 
%     stimuli in determining the padAmount. if S1 and S2 stimuli have different 
%     trial counts, e.g. due to imbalanced rates of stimuls presentation or 
%     due to the task being a 'detect x' task in which the number of S1 trials 
%     at x=0 may differ from the number of S2 trials for each level of x > 0,
%     then using a fixed padAmount can differentially affect S1 and S2
%     stimuli and thereby introduce biases into SDT calculations e.g. of d'. 
% 
%     this correction works by first determining which of nTrialsPerX_S1
%     and nTrialsPerX_S2 is larger, where nTrialsPerX_S1 and nTrialsPerX_S2 
%     are the number of trials per level of stimulus x for S1 and S2 stimuli, 
%     respectively. info.padAmount is used as the padAmount for the
%     stimulus with higher trial count, and the padAmount for the stimulus
%     with the lower trial count is reduced by the ratio of trial counts.
%     
%     for instance, suppose nTrialsPerX_S1 > nTrialsPerX_S2. then
% 
%     padAmount_S1 = info.padAmount
%     padAmount_S2 = info.padAmount * (nTrialsPerX_S2 / nTrialsPerX_S1)
%     
%     such that the padAmount for S2 is lower than that for S1 by the same
%     proportion as the trial counts per level of x are lower for S2 than
%     for S1. this ensures e.g. that if S1 and S2 have imbalanced trial
%     counts, then padding will not bias calculation of d' and meta-d'. for 
%     instance, without this correction, imbalanced trial counts could result 
%     in non-zero values of d' even when the uncorrected HR is equal to the 
%     uncorrected FAR, which should result in d' = 0.
% 
%   * DEFAULT is 0, but recommended value is 1 if S1 and S2 stimuli have 
%     imbalanced trial counts per level of x.
% 
% info.padCells_nonzero_d
%   - boolean controlling whether response count cells nR_S1 and nR_S2 are
%     padded to prevent a value of d' = 0 from interfering with meta-d'
%     analysis (meta-d' is undefined when d' = 0 since fitting meta-d'
%     requires using c' = c/d')
%   - this is done by adding a very small amount (info.padAmount_nonzero_d) 
%     to response counts for correct rejections and hits, i.e. nR_S1(1:nRatings) 
%     and nR_S2(nRatings+1:end), if info.padCells_nonzero_d == 1
%   * DEFAULT is 0, but recommended value is 1 if any conditions in the
%     data to be fitted yield d' = 0
% 
% info.padAmount_nonzero_d
%   - amount to add to nR_S1(1:nRatings) and nR_S2(nRatings+1:end) if
%     info.padCells_nonzero_d == 1
%   * DEFAULT is 1e-4
% 
% info.PF
%   - this should be set to one of the "scaled" PFs as returned by
%     RPF_get_PF_list('PFs_scaled')
% 
% info.set_P_min_to_d_pad_min
%   - boolean controlling whether info.P_min is set to info.padInfo.d_pad_min 
%     in cases where info.padCells == 1 and info.P_min is not already
%     specified
%     (see "info.P_max and info.P_min when using cell padding" below)
%   * DEFAULT is 0, but recommended value is 1 if using cell padding
%
% info.set_P_max_to_d_pad_max
%   - boolean controlling whether info.P_max is set to info.padInfo.d_pad_max 
%     in cases where info.padCells == 1 and info.P_max is not already
%     specified
%     (see "info.P_max and info.P_min when using cell padding" below)
%   * DEFAULT is 0, but recommended value is 1 if using cell padding
%
% info.P_min and info.P_max when using cell padding
%   - for d', if info.padCells == 1 and info.padAmount > 0, then this sets 
%     an upper bound on the maximum possible computed value for d'. this 
%     follows from the fact that the maximum possible hit rate HR and 
%     minimum possible false alarm rate FAR under cell padding are
%
%     HR_pad_max  = (nTrialsPerX_S2 +     padAmount_S2 * nRatings + padAmount_nonzero_d * nRatings) / ...
%                   (nTrialsPerX_S2 + 2 * padAmount_S2 * nRatings + padAmount_nonzero_d * nRatings);
%     FAR_pad_min = (                     padAmount_S1 * nRatings) / ...
%                   (nTrialsPerX_S1 + 2 * padAmount_S1 * nRatings + padAmount_nonzero_d * nRatings);
%
%     where nTrialsPerX_S1 and and nTrialsPerX_S2 are the number of trials 
%     per level of stimulus x for S1 and S2 stimuli, respectively, and 
%     nRatings and padAmount_nonzero_d are defined as in info.nRatings 
%     and info.padAmount_nonzero_d, and padAmount_S1 and padAmount_S2 are 
%     determined by info.padAmonut and info.padCells_correctForTrialCounts.
%     
%     thus, the maximum possible value that can be computed for d' is the 
%     value achieved when using HR_pad_max and FAR_pad_min:
% 
%     d_pad_max = norminv(HR_pad_max) - norminv(FAR_pad_min)
%
%   - similarly if info.padCells == 1 and info.padAmount_nonzero_d > 0,
%     this sets a minimum possible value for d' corresponding to minimum 
%     values for HR and FAR. the exact value one computes for this minimum 
%     d' depends on padding settings, trial counts for S1 and S2, and the
%     type 1 criterion. the toolbox computes d_pad_min by finding the rate
%     of responding R where R = unpadded HR = unpadded FAR that minimizes 
%
%     d_pad_min = norminv(padded HR) - norminv(padded FAR)
%
%     this value is very small for small values of padAmount_nonzero_d. for
%     instance, if nTrialsPerX_S1 = nTrialsPerX_S1 = 50 and default values
%     for info.padAmount and info.padAmount_nonzero_d are used, then 
%     d_pad_min ~= 5e-6.
%
%   - for d' estimated with cell padding, it is thus recommended to define 
%     info.P_max and info.P_min to correspond to the max and min values
%     possible with the specified padding settings. this can be achieved by
%     declining to specify values for info.P_min and info.P_max, and insetad 
%     setting info.set_P_max_to_pad_max == 1 and  info.set_P_max_to_pad_max 
%     == 1, as noted above. 
%
%   - for meta-d' estimated with cell padding, you may also want to use
%     these settings, if it is appropriate in your data set to assume that 
%     the max and min possible values for meta-d' must be the same as the
%     max and min possible values for d'.
%
% info.P_min and info.P_max when NOT using cell padding
%   - if not using cell padding in the estimation of d' or meta-d', then:
%     - the recommended value for info.P_min is 0
%     - the recommended value for info.P_max is a large signal-to-noise ratio 
%       value, such as 5. technically there is no upper limit on d' or meta-d' 
%       values, but in practice it is useful to define a finite value for 
%       P_max corresponding to very high but reasonable performance. for 
%       instance, for unbiased responding, p(correct) can be computed as 
%       normcdf(d'/2), and so d'=5 corresponds to p(correct) = 0.994, very 
%       close to the "true" maximum value of p(correct) = 1 at which d' = Inf. 
%       adjust P_max as needed for your data and use case.