function [P, xt] = RPF_eval_F(F, x, is_xt)
% [P, xt] = RPF_eval_F(F, x, is_xt)
% 
% Evaluate the psychometric functions P = F(xt) for each condition.
%
% INPUTS
% ------
% F     - the F struct. see RPF_guide('F')
% x     - an array of x values at which to evaluate F. these are transformed
%         into xt values by xt_fn prior to the function evaluation, unless 
%         the optional input is_xt == 1.
%         x may be of size [1, nx] or [nCond, nx]. if size [1, nx], then
%         every condition is evaluated at these values of x. if size [nCond,
%         nx], then the output P(i_cond, :) is evaluated at x(i_cond, :)
%         for all conditions i_cond.
% is_xt - optional input that, if set to 1, signals that the input variable
%         x has already been transformed to xt. in this case, xt_fn is not
%         applied to the input x prior to the function evaluation.
%       * DEFAULT is 0
%
% OUTPUTS
% -------
% P  - a matrix of size [nCond, length(x)] that contains F(xt) for each
%      condition
% xt - the array of xt values used to compute P


%% process x

if ~exist('is_xt', 'var') || isempty(is_xt)
    is_xt = 0;
end

if is_xt
    xt = x;
else
    xt = F.fit(1).xt_fn( x );
end


%% evaluate F(xt)

PF = F.fit(1).PF;

for i_cond = 1:length(F.fit)
    params = F.fit(i_cond).params;
    
    if size(xt,1) == 1
        P(i_cond,:) = PF( params, xt );
    elseif size(xt,1) == F.info.nCond
        P(i_cond,:) = PF( params, xt(i_cond,:) );
    end
end