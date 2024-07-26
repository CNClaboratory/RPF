% RPF_guide_utilities
%
% Description of utilities and helper functions available in the RPF toolbox.
%
% Aside from the functions used in the main workflow of the toolbox (see
% RPF_guide('workflow')), there are several complementary functions
% available in the toolbox that may be useful for working with your data.
%
% GENERAL UTILITIES
% -----------------
% RPF_guide
%   - contains documentation and guidance on various aspects of the toolbox
%
% RPF_check_toolboxes
%   - checks if all supporting toolboxes are found in the Matlab path, and
%     if not prints a notification to the prompt
%   - for more, see RPF_guide('toolboxes')
%
% RPF_get_PF_list
%   - list different psychometric functions available in the RPF toolbox,
%     organized by various characteristics
%
% RPF_get_DV_list
%   - list different dependent variables available for analysis in the RPF 
%     toolbox, organized by various characteristics
%
% TRIALDATA UTILITIES
% -------------------
% These functions are used internally in the normal RPF toolbox workflow,
% but may also be useful for independent usage by the user, or to give
% insight into how these operations on trialData work. See 
% RPF_guide('trialData') for more on the trialData struct.
%
% RPF_filter_trialData
%   - filters out trials from the trialData struct according to specified input
%
% RPF_get_thresh_for_med_split
%   - determines the threshold for binarizing trial-by-trial ratings that
%     best balances trial counts for "low" and "high" ratings
%
% F AND R STRUCT UTILITIES
% ------------------------
% These functions operate by taking the F or R structs as input, thereby
% simplifying basic operations such as evaluating P = F(x) for any values
% of x using the information in the F struct. See RPF_guide('F') and 
% RPF_guide('R') for more on the F and R structs. 
% 
% RPF_eval_xt_fn
%   - using the F struct, evaluate the x transform xt = xt_fn(x) for input
%     xt
%
% RPF_eval_xt_fn_inv
%   - using the F struct, evaluate the x transform x = xt_fn_inv(xt) for
%     input x
%   
% RPF_eval_F
%   - using the F struct, evaluate the psychometric functions P = F(xt) 
%     for input x or xt, separately for each condition
%
% RPF_eval_F_inv
%   - using the F struct, evaluate the inverse of the psychometric function 
%     xt = F^-1(P) for input P, separately for each condition
%
% RPF_eval_R
%   - using the R struct, evaluate the relative psychometric functions 
%     P2 = R(P1) for input P1, separately for each condition
%
% REFORMATTING THE F AND R STRUCTS
% --------------------------------
% RPF_structArray2fieldMatrix
%   - reformats F structs and R structs so that across-condition data is
%     stored in field matrices rather than struct arrays, which may make
%     manually working with the data easier in some use cases
%   - note that all RPF toolbox functions assume default formatting for F
%     and R, and so reformatted F and R structs will not work with the rest
%     of the toolbox
%
% RPF ANALYSIS
% ------------
% RPF_AUC
%   - using the R struct, compute RPF_AUC for a specified P1 range,
%     separately for each condition
%
% RPF_plot
%   - using the F or R structs, flexibly plot the results of the data 
%     analysis and psychometric function fitting
%   - optionally customize plots using the plotSettings struct
%   - see RPF_guide('plotSettings') for details

