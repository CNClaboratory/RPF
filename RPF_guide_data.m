% RPF_guide_data
%
% Description of the data struct array used in the RPF toolbox. 
% 
% data is a 1 x nCond struct array whose fields contain summary information 
% of the trial-by-trial data in the trialData struct, as specified in the 
% info struct. (See RPF_guide('info') and RPF_guide('trialData') for more 
% information about these structs.) Each element in the data struct array 
% holds data for each experimental condition. data is generated by the 
% function RPF_get_F_data, and its contents are used for fitting the 
% psychometric function in RPF_fit_F_data. 
%
% Some fields of data are universal, but many depend on the dependent
% variable being analyzed, as specified in info.DV. Some fields are also 
% redundant with information available elsewere, e.g. in the info struct, 
% for ease of access. 
%
% Below is a listing of the fields of data for each type of DV.
%
% UNIVERSAL FIELDS
% 
% The following fields are contained in data for all DV types. In the
% below, i_cond is an index referring to condition number.
%
% data(i_cond).condLabel
%   - a string providing a label for the condition i_cond
%   - identical to info.cond_labels{i_cond}
%
% data(i_cond).DV
%   - a string providing a label the DV being analyzed
%   - identical to info.DV
%
% data(i_cond).x
%   - a sorted list of all unique x values used in the experiment
%   - identical to info.x_vals
%   - see RPF_guide('trialData') for more information on how x values
%     should be defined in the RPF toolbox, and RPF_guide('info') for more
%     information on the calculation of info.x_vals
%
% data(i_cond).xt
%   - transformation of data(i_cond).x using info.xt_fn
%   - identical to info.xt_vals
%
% data.P
%   - a summary measure of the DV at each level of data.x
%   - e.g. if info.DV is 'p(correct)', then data(i_cond).P holds values of
%     p(correct) at each level of data(i_cond).x
%
% RESPONSE-CONDITIONAL DVs
% 
% Response-specific analys is available for the following DVs: p(correct),
% p(high rating), mean rating, meta-d', type 2 AUC, and RT. These DVs
% therefore also have the following data field:
% 
% data(i_cond).DV_respCond
%   - specifies which response types are included in the data analysis
%   - identical to info.DV_respCond
%   - see RPF_guide('info') section "Response-specific analysis" for more
% 
% FIELDS BY DV TYPE
%
% DV = p(response), p(correct), or p(high rating)
% -----------------------------------------------
% data(i_cond).forMLE.nPos
%   - a count of the number of positive trials at each level of
%     data(i_cond).x
%   - e.g. if DV = p(correct), then nPos holds the number of correct trials
%     for each level of x
%   - use by RPF_fit_F for MLE fitting
%
% data(i_cond).forMLE.nTot
%   - a count of the number of overall trials at each level of
%     data(i_cond).x
%   - use by RPF_fit_F for MLE fitting
%
% DV = mean rating
% ----------------
% data(i_cond).pHighRating(i_rating)
%   - a struct containing information on the p(high rating) DV for each 
%     value of i_rating in [1, nRatings-1], where "high rating" is defined 
%     as rating >= (i_rating+1)
%   - specifically, pHighRating(i_rating) contains fields P, forMLE.nPos, 
%     and forMLE.nTot as these are defined for the p(high rating) DV
%   - these data are used for MLE fitting of each p(high rating) curve,
%     which in turn are used to construct the MLE fit for mean rating
%
% DV = d'
% -------
% data(i_cond).d_pad_min and data(i_cond).d_pad_max
%   - min and max values for d', given the cell padding settings specified
%     in the info struct (see RPF_guide('info') section "Fitting d' and 
%     meta-d'" for more)
%   - identical to data(i_cond).padInfo.d_pad_min and
%     data(i_cond).padInfo.d_pad_max (see RPF_guide('padInfo') for more)
%
% data(i_cond).nRatings
%   - number of ratings in the rating scale (e.g. for confidence,
%     awareness, etc.)
%   - identical to info.nRatings
%
% data(i_cond).forMLE.nH
%   - a count of the number of hits at each level of data(i_cond).x
%   - used by RPF_fit_F for MLE fitting of d'
%
% data(i_cond).forMLE.nF, nM, nCR
%   - similar to data(i_cond).forMLE.nH, but for false alarms, misses, and
%     correct rejections, respectively
%   - used by RPF_fit_F for MLE fitting of d'
%
% data(i_cond).counts
%   - contains information on response counts used for SDT analysis
%   - see RPF_guide('counts') for more
%
% data(i_cond).padInfo
%   - contains information on cell padding settings used for SDT analysis
%   - see RPF_guide('padInfo') for more
%
% data(i_cond).SDT
%   - contains some basic SDT analyses of the data
%
% DV = meta-d'
% ------------
% The data struct when DV = meta-d' contains the same fields as the data
% struct when DV = d', except the contents of the forMLE struct are
% different, and there is an extra field named md_fit.
%
% data(i_cond).forMLE.nC_rS1
%   - a count of the number of ratings given for correct "S1" responses at
%     each level of data(i_cond).x
%   - identical to data(i_cond).counts.nC_rS1 
%   - see RPF_guide('counts') for more
%   - applicable when data(i_cond).DV_respCond = 'rS1' or 'all'
%   - used by RPF_fit_F for MLE fitting of meta-d'
%
% data(i_cond).forMLE.nI_rS1
%   - a count of the number of ratings given for incorrect "S1" responses at
%     each level of data(i_cond).x
%   - identical to data(i_cond).counts.nI_rS1 
%   - see RPF_guide('counts') for more
%   - applicable when data(i_cond).DV_respCond = 'rS1' or 'all'
%   - used by RPF_fit_F for MLE fitting of meta-d'
%
% data(i_cond).forMLE.nC_rS2
%   - a count of the number of ratings given for correct "S2" responses at
%     each level of data(i_cond).x
%   - identical to data(i_cond).counts.nC_rS2 
%   - see RPF_guide('counts') for more
%   - applicable when data(i_cond).DV_respCond = 'rS2' or 'all'
%   - used by RPF_fit_F for MLE fitting of meta-d'
%
% data(i_cond).forMLE.nI_rS2
%   - a count of the number of ratings given for incorrect "S2" responses at
%     each level of data(i_cond).x
%   - identical to data(i_cond).counts.nI_rS2 
%   - see RPF_guide('counts') for more
%   - applicable when data(i_cond).DV_respCond = 'rS2' or 'all'
%   - used by RPF_fit_F for MLE fitting of meta-d'
%
% data(i_cond).md_fit
%   - contains selected information from the meta-d' fits to the data at 
%     each level of data(i_cond).x as returned by the meta-d' toolbox 
%     functions fit_meta_d_MLE (if DV_respCond = 'all') or fit_rs_meta_d_MLE 
%     (if DV_respCond = 'rS1' or 'rS2')
%
% DV = type 2 AUC
% ---------------
% data(i_cond).nRatings
%   - number of ratings in the rating scale (e.g. for confidence,
%     awareness, etc.)
%   - identical to info.nRatings
%
% data(i_cond).t2AUC.Ag_obs
%   - area under the type 2 ROC curve at each level of data(i_cond).x as 
%     computed by the area measure Ag, which computes area as the summed 
%     areas of the trapezoids defined by the type 2 HR and type 2 FAR data
%
% data(i_cond).t2AUC.Ag_exp
%   - expected area under the type 2 ROC curve at each level of data(i_cond).x 
%     as computed by the area measure Ag
%   - expected area is defined as the area expected from the SDT model
%     assuming the observer is metacognitively optimal according to SDT.
%     thus, Ag_exp : Ag_obs :: d' : meta-d'
%   - SDT predicts fully continuous type 2 ROC curves, which in general
%     will have greater AUC than the area computed from only a handful of
%     type 2 HR and FAR data points using the trapezoidal measure Ag.
%     therefore, to put Ag_exp on the same footing as Ag_obs, Ag_exp is
%     computed by averaging the Ag derived from using the SDT-predicted
%     type 2 FAR at the empirically observed type 2 HR, and the
%     SDT-predicted type 2 HR at the empirically observed type 2 FAR.
%
% data(i_cond).counts
%   - contains information on response counts used for SDT analysis
%   - see RPF_guide('counts') for more
% 
% data(i_cond).padInfo
%   - contains information on cell padding settings used for SDT analysis
%   - see RPF_guide('padInfo') for more
%
% data(i_cond).SDT
%   - contains some basic SDT analyses of the data
%
% DV = RT
% -------
% When DV = RT, only the universal fields listed above are contained in
% data(i_cond).