function x = RPF_eval_xt_fn_inv(F, xt)
% x = RPF_eval_xt_fn_inv(F, xt)
% 
% Evaluate the inverse x transform x = xt_fn_inv(xt).
%
% INPUTS
% ------
% F  - the F(x) struct
% xt - an array of xt values at which to evaluate xt_fn_inv
%
% OUTPUTS
% -------
% x - the array of inverse-transformed x values

x = F.fit(1).xt_fn_inv( xt );