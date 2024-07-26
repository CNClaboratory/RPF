% RPF_guide_searchGrid
%
% Description of the searchGrid struct used in the RPF toolbox.
%
% Note that for simplicity, the below refers to the searchGrid and
% constrain structs themselves, but in the RPF toolbox workflow these are
% contained within the info struct. See RPF_guide('info') for more details.
%
% searchGrid is a struct used to initialize parameter estimates for the 
% psychometric function fitting algorithm. It contains fields with lists of
% values for the four PF parameters alpha, beta, gamma, and lambda (or
% omega for scaled PFs). In preparation for fitting the PF to the data, 
% every permutation of these lists of parameter values is tested on the data 
% to be fitted, and the permutation yielding the highest likelihood (or 
% lowest SSE) is used as the initial guess for the PF fitting algorithm.
%
% As discussed below, fields of searchGrid may be constrained in accordance
% with the settings of the constrain struct (see RPF_guide('constrain')).
% Some settings differ depending on whether the relevant psychometric is a
% scaled PF or not. See RPF_get_PF_list('PFs_scaled') for a list of scaled
% PFs.
% 
% In most cases it suffices to allow the RPF toolbox to use default
% settings for searchGrid, but if desired searchGrid can also be defined
% manually in the info struct (see RPF_guide('info')). You can choose to
% only manually define some of the fields of searchGrid, in which case the
% unspecified ones will be set to their default values. Note that any
% settings for fixing parameter values in the constrain struct will
% automatically overwrite any manually defined settings of the searchGrid 
% fields. Default settings for searchGrid are made in RPF_default_searchGrid.
%
% searchGrid is a struct also used in the Palamedes toolbox, although in
% the RPF toolbox usage it is extended to account for the case of scaled
% PFs. See https://www.palamedestoolbox.org/weibullandfriends.html for
% example Palamedes documentation on the searchGrid struct.
%
% searchGrid.alpha
%   - a list of values of the location parameter alpha over which to search 
%     for the initial parameter estimate 
%   - if manually defining searchGrid.alpha, note that this must be expressed 
%     on the scale of the transformed x-axis as defined by info.xt_fn. e.g. 
%     if you want to list alpha values as A = [.1 : .1 : 1] and your PF uses 
%     a log10 transform on x, then you would set searchGrid.alpha = log10(A).
%     see RPF_get_PF_list('PFs_log') for a list of PFs in the RPF toolbox
%     using a log10 transform on the x-axis
%   - if constrain.value.alpha is defined, then searchGrid.alpha is set to
%     constrain.value.alpha, overwriting any manually defined settings
%   * DEFAULT is info.xt_fn([.05:.05:3])
%
% searchGrid.beta
%   - a list of values of the slope parameter beta over which to search for
%     the initial parameter estimate 
%   - if constrain.value.beta is defined, then searchGrid.beta is set to
%     constrain.value.beta, overwriting any manually defined settings
%   * DEFAULT is 10.^(-1:.1:1)
%
% searchGrid.gamma
%   - a list of values of the chance performance parameter gamma over which 
%     to search for the initial parameter estimate 
%   - if constrain.value.gamma is defined, then searchGrid.gamma is set to
%     constrain.value.gamma, overwriting any manually defined settings
%   * DEFAULT is 
%       - scaled PF -> linspace(info.P_min, info.P_max, 11)
%       - otherwise -> 0:.1:1
%
% searchGrid.lambda (for unscaled PFs)
%   - a list of values of the lapse rate parameter lambda over which to 
%     search for the initial parameter estimate 
%   - if constrain.value.lambda is defined, then searchGrid.lambda is set to
%     constrain.value.lambda, overwriting any manually defined settings
%   * DEFAULT is 0:.1:1
%
% searchGrid.omega (for scaled PFs)
%   - a list of values of the asymptotic performance parameter omega over 
%     which to search for the initial parameter estimate 
%   - if constrain.value.omega is defined, then searchGrid.omega is set to
%     constrain.value.omega, overwriting any manually defined settings
%   * DEFAULT is linspace(info.P_min, info.P_max, 10)