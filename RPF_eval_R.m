function P2 = RPF_eval_R(R, P1, method)
% P2 = RPF_eval_R(R, P1)
% 
% Evaluate the relative psychometric functions P2 = R(P1) for each condition.
%
% INPUTS
% ------
% R      - the R struct. see RPF_guide('R')
% P1     - an array of P1 values at which to evaluate R
% method - method for computing R(P1). if 'analytical', an analytical
%          solution will be employed if possible using R.info.PF. if 
%          'numerical' or if R.info.PF is undefined, a numerical approach 
%          will be employed by computing P2 from P1 via inverting F1, i.e.
%
%            x1 = RPF_eval_F_inv(R.F1, P1)
%            P2 = RPF_eval_F(R.F2, x1)
%
%          note that if F1 was interpolated, then F1 is not invertible, which
%          disallows the numerical method. this entails that F2 must be 
%          interpolated as well, and the RPF is described by the special
%          function @RPF_interp_RPF. in this case, method is automatically 
%          set to 'analytical' regardless of the input value, and 
%          @RPF_interp_RPF is used to compute P2 = R(P1). 
%
%        * DEFAULT depends on whether F1 was fitted or interpolated.
%          - if F1 was fitted, then method defaults to 'numerical' since 
%            numerical methods can be more robust in cases of extreme 
%            parameter values in the fits for F1 or F2, e.g. infinite slope.  
%          - if F1 was interpolated, method defaults to 'analytical' 
%            regardless of the input value, per the above discussion 
%
% OUTPUTS
% -------
% P2 - a matrix of size [nCond, length(P1)] that contains R(P1) for each
%      condition

%% set default method

if ~exist('method', 'var') || isempty('method')
    method = 'numerical';
end

% for interpolated RPFs, force method to be 'analytical'
if isfield(R.info, 'PF') && isa(R.info.PF, 'function_handle') && strcmp(func2str(R.info.PF), 'RPF_interp_RPF')
    method = 'analytical';
end

%% 

% if there is a function for computing P2 = R(P1), use that
if strcmp(method, 'analytical') && isfield(R.info, 'PF') && isa(R.info.PF, 'function_handle')
    P2 = R.info.PF(R, P1);

% else, compute xt1 = F^-1(P1) and then P2 = F2(xt1)
else
    x1 = RPF_eval_F_inv(R.F1, P1);
    P2 = RPF_eval_F(R.F2, x1);
end