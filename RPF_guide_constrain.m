% RPF_guide_constrain
%
% Description of the constrain struct used in the RPF toolbox. 
%
% The constrain struct specifies what constraints (if any) should be placed
% on the parameters of the psychometric function when being fitted to the
% data. It should be specified as a field of the info struct (see
% RPF_guide('info') for more).
%
% Currently, constrain only supports setting a fixed a priori value for any
% of the 4 psychometric function parameters of alpha, beta, gamma, and
% lambda (or omega for scaled PFs). Future releases of the RPF toolbox may
% support setting more flexible constraints.
%
% constrain.value.alpha
%   - if specified and not empty, the alpha parameter of the PF fit will be
%     constrained to equal constrain.value.alpha
%   - if setting a fixed value for alpha, this must be expressed on the
%     scale of the transformed x-axis as defined by info.xt_fn. e.g. if you
%     want to constrain alpha to occur at a value of contrast = 0.5 and
%     your PF uses a log10 transform on x, then you would set
%     constrain.value.alpha = log10(0.5)
%   - see RPF_get_PF_list('PFs_log') for a list of PFs in the RPF toolbox
%     using a log10 transform on the x-axis
%
% constrain.value.beta
%   - if specified and not empty, the beta parameter of the PF fit will be
%     constrained to equal constrain.value.beta
%
% constrain.value.gamma
%   - if specified as the string 'P_min', defaults to the value of
%     info.P_min when info is updated via RPF_update_info
%   - if otherwise specified and not empty, the gamma parameter of the PF 
%     fit will be constrained to equal constrain.value.gamma
%   - accuracy-based DVs have a natural fixed value for gamma corresponding
%     to the level of chance performance, e.g. gamma = 0.5 for p(correct)
%     or gamma = 0 for d'.
%
% constrain.value.lambda
%   - if specified and not empty, the lambda parameter of the PF fit will be
%     constrained to equal constrain.value.lambda
%   - this constraint applies to PFs that fit response probabilities and
%     therefore have a lambda parameter; see RPF_get_PF_list('PFs_respProb')
%     for a list of relevant PFs available in the RPF toolbox
%
% constrain.value.omega
%   - if specified as the string 'P_max', defaults to the value of
%     info.P_max when info is updated via RPF_update_info
%   - if otherwise specified and not empty, the omega parameter of the PF 
%     fit will be constrained to equal constrain.value.omega
%   - this constraint applies to PFs that fit scaled psychometric functions 
%     and therefore have an omega parameter; see RPF_get_PF_list('PFs_scaled')
%     for a list of relevant PFs available in the RPF toolbox