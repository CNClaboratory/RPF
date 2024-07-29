function P2 = RPF_eval_R(R, P1)
% P2 = RPF_eval_R(R, P1)
% 
% Evaluate the relative psychometric functions P2 = R(P1) for each condition.
%
% INPUTS
% ------
% R  - the R struct. see RPF_guide('R')
% P1 - an array of P1 values at which to evaluate R
%
% OUTPUTS
% -------
% P2 - a matrix of size [nCond, length(P1)] that contains R(P1) for each
%      condition

% if there is a function for computing P2 = R(P1), use that
if isfield(R.info, 'PF') && isa(R.info.PF, 'function_handle')
    P2 = R.info.PF(R, P1);

% else, compute xt1 = F^-1(P1) and then P2 = F2(xt1)
else
    x1 = RPF_eval_F_inv(R.F1, P1);
    P2 = RPF_eval_F(R.F2, x1);
end