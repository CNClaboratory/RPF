function xt = RPF_eval_xt_fn(F, x)
% xt = RPF_eval_xt_fn(F, x)
% 
% Evaluate the x transform xt = xt_fn(x).
%
% INPUTS
% ------
% F - the F struct. see RPF_guide('F')
% x - an array of x values at which to evaluate xt_fn
%
% OUTPUTS
% -------
% xt - the array of transformed x values

xt = F.fit(1).xt_fn( x );