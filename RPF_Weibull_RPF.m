function P2 = RPF_Weibull_RPF(R, P1, filter_P1)
% P2 = RPF_Weibull_RPF(R, P1, filter_P1)
%
% Use the Weibull RPF to compute P2 = R(P1) for each condition.
%
% INPUTS
% ------
% R         - the R struct. see RPF_guide('R')
% P1        - an array of P1 values at which to evaluate R
% filter_P1 - if set to 1, removes any values from P1 that might cause
%             numerical issues such as imaginary solutions, e.g. due to
%             being lower than F1(xt_min), being higher than F1(xt_max), or 
%             being equal to 1 (or nearly so)
%           * DEFAULT = 0
%
% OUTPUTS
% -------
% P2 - a matrix of size [nCond, length(P1)] that contains R(P1) for each
%      condition


%% handle inputs

if ~exist('P1','var') || isempty(P1)
    P1_grain = 1e-5;
    P1 = R.info.P1_LB_min : P1_grain : R.info.P1_UB_max;
end

if ~exist('filter_P1','var') || isempty(filter_P1)
    filter_P1 = 0;
end

if filter_P1
    f_low  = P1 < R.info.P1_LB_min;
    f_high = P1 > R.info.P1_UB_max;
    f_one  = abs(P1-1) < 1e-3;
    
    f = f_low & f_high & f_one;
    P1(~f) = [];
    
    if sum(f) > 0
        warnText = ['In the input R struct, \n' ...
                    '- P1 at x min = ' regexprep(num2str(R.info.P1_at_x_min', 2),   '\s+', ', ') '\n' ...
                    '- P1 at x max = ' regexprep(num2str(R.info.P1_at_x_max', 2),   '\s+', ', ') '\n\n' ...
                    'Some of the input values for P1 exceed these bounds, and/or are nearly equal to 1. ' ...
                    'This can cause numerical issues such as imaginary solutions for P2. ' ...
                    num2str(sum(f)) 'entries in P1 have been removed to avoid these issues.'];
        warning('RPF:invalidInput', warnText);
    end
    
else

    if any(P1 < R.info.P1_LB_min) || any(P1 > R.info.P1_UB_max)
        warnText = ['In the input R struct, \n' ...
                    '- P1 at x min = ' regexprep(num2str(R.info.P1_at_x_min', 2),   '\s+', ', ') '\n' ...
                    '- P1 at x max = ' regexprep(num2str(R.info.P1_at_x_max', 2),   '\s+', ', ') '\n\n' ...
                    'Some of the input values for P1 exceed these bounds, which may cause ' ...
                    'numerical issues such as imaginary solutions for P2.'];
        warning('RPF:invalidInput', warnText);
    end

    if any( abs(P1-1) < 1e-3 )
        warnText = ['Some of the input values for P1 are very close to 1, which may cause ' ...
                    'numerical issues such as imaginary solutions for P2.'];
        warning('RPF:invalidInput', warnText);
    end
end


%% compute the Weibull RPF

for i_cond = 1:R.info.nCond

    %% handle inputs

    alpha1  = R.fit(i_cond).params.F1(1);
    beta1   = R.fit(i_cond).params.F1(2);
    gamma1  = R.fit(i_cond).params.F1(3);
    lambda1 = R.fit(i_cond).params.F1(4);

    alpha2  = R.fit(i_cond).params.F2(1);
    beta2   = R.fit(i_cond).params.F2(2);
    gamma2  = R.fit(i_cond).params.F2(3);
    lambda2 = R.fit(i_cond).params.F2(4);

    %% compute R(P1)

    P2_exp = (alpha2/alpha1)^-beta2 * ( log( (1 - lambda1 - gamma1) ./ (1 - lambda1 - P1) ) ).^(beta2/beta1);

    P2(i_cond, :) = gamma2 + (1 - gamma2 - lambda2) .* (1 - exp( -P2_exp ));

end