function [AUC, P2_avg] = RPF_AUC(R, P1_LB, P1_UB, P1_grain)
% [AUC, P2_avg] = RPF_AUC(R, P1_LB, P1_UB, P1_grain)
%
% Compute area under the RPF curve for each condition.
%
% INPUTS
% ------
% R        - the R struct. see RPF_guide('R')
% P1_LB    - lower bound on the P1 axis for computing RPF AUC. must be no
%            smaller than R.info.P1_LB_min
%          * DEFAULT value is R.info.P1_LB_min
% P1_UB    - upper bound on the P1 axis for computing RPF AUC. must be no
%            larger than R.info.P1_UB_max
%          * DEFAULT value is R.info.P1_UB_max
% P1_grain - in cases where a function handle for the RPF is not specified, 
%            the RPF AUC is computed by numerical integration over [P1_LB :
%            P1_grain : P1_UB], so smaller values of P1_grain lead to more 
%            precise AUC estimates.
%          * DEFAULT value is 1e-5.
% method   - method for computing R(P1). if 'analytical', an analytical
%            solution will be employed if possible using R.info.PF. if 
%            'numerical' or if R.info.PF is undefined, a numerical approach 
%            will be employed by computing P2 from P1 via inverting F1, i.e.
%
%              x1 = RPF_eval_F_inv(R.F1, P1)
%              P2 = RPF_eval_F(R.F2, x1)
%
%            note that if F1 was interpolated, then F1 is not invertible, which
%            disallows the numerical method. this entails that F2 must be 
%            interpolated as well, and the RPF is described by the special
%            function @RPF_interp_RPF. in this case, method is automatically 
%            set to 'analytical' regardless of the input value, and 
%            @RPF_interp_RPF is used to compute P2 = R(P1). 
%
%          * DEFAULT depends on whether F1 was fitted or interpolated.
%            - if F1 was fitted, then method defaults to 'numerical' since 
%              numerical methods can be more robust in cases of extreme 
%              parameter values in the fits for F1 or F2, e.g. infinite slope.  
%            - if F1 was interpolated, method defaults to 'analytical' 
%              regardless of the input value, per the above discussion 
%
% OUTPUTS
% -------
% AUC    - 1 x nCond vector holding RPF AUC for each condition
% P2_avg - 1 x nCond vector holding the average P2 value over the P1 range
%          for each condition, where P2_avg = AUC ./ (P1_UB - P1_LB)


%% handle inputs

if ~exist('P1_LB', 'var') || isempty(P1_LB)
    P1_LB = R.info.P1_LB;
end

if ~exist('P1_UB', 'var') || isempty(P1_UB)
    P1_UB = R.info.P1_UB;
end

if ~exist('P1_grain', 'var') || isempty(P1_grain)
    P1_grain = 1e-5;
end

if P1_LB < R.info.P1_LB_min
    error('input P1_LB is less than R.info.P1_LB_min')
end

if P1_UB > R.info.P1_UB_max
    error('input P1_UB is greater than R.info.P1_UB_max')
end

if (P1_LB == P1_UB) || (P1_UB - P1_LB) < P1_grain
    error('input P1_LB and P1_UB must differ by at least P1_grain')
end

if any(strcmp(RPF_get_PF_list('PFs_respProb'), func2str(R.F1.info.PF))) && P1_UB >= 1
    warnText = ['The PF for R.F1 fits response probabilities, and P1_UB was entered as ' num2str(P1_UB) '. ' ...
                'This may cause numerical issues when inverting F1 to compute the AUC, such as getting imaginary ' ...
                'values for x. You may want to adjust your input so that P1_UB is a value slightly less than 1, ' ...
                'e.g. P1_UB = 1 - 1e-3.'];
    warning('RPF:numericalIssue', warnText);
end

if ~exist('method', 'var') || isempty('method')
    method = 'numerical';
end

% for interpolated RPFs, force method to be 'analytical'
if isfield(R.info, 'PF') && isa(R.info.PF, 'function_handle') && strcmp(func2str(R.info.PF), 'RPF_interp_RPF')
    method = 'analytical';
end


%% compute P2 = R(P1)

P1 = P1_LB : P1_grain : P1_UB;
P2 = RPF_eval_R(R, P1, method);


%% filter out any bad values

% exclude NaN, Inf, and imaginary values
f_nan  = isnan(P2);     % find NaN entries across all i_cond x P1 values
f_inf  = isinf(P2);     % find Inf entries
f_imag = imag(P2) ~= 0; % find entries with non-zero imaginary component

f_bad = f_nan | f_inf | f_imag;
f_bad = sum(f_bad, 1);  % combine filter entries across i_cond

% print a warning message about bad values if there are any bad values for
% P2 besides the first or last value. note that it is not unusual for bad
% values to occur at the first or last entries in the array due to
% negligible numerical issues
if sum(f_bad(2:end-1)) > 0 
    warnText = ['In computing ' num2str(numel(P2)) ' total P2 values over ' num2str(size(P2,1)) ' conditions for the P1 interval [' num2str(P1_LB) ' : ' num2str(P1_grain) ' : ' num2str(P1_UB) '], ' ...
                'the following bad values for P2 occurred:\n\n' ...
                '- NaN: ' num2str(sum(f_nan(:))) ' values (' num2str(100*sum(f_nan(:)) / numel(P2)) '%%)\n' ...
                '- Inf: ' num2str(sum(f_inf(:))) ' values (' num2str(100*sum(f_inf(:)) / numel(P2)) '%%)\n' ...
                '- non-zero imaginary component: ' num2str(sum(f_imag(:))) ' values (' num2str(100*sum(f_imag(:)) / numel(P2)) '%%)\n\n' ...
                'Overall, ' num2str(sum(f_bad(:))) ' values (' num2str(100*sum(f_bad(:)) / length(P1)) '%%) of the P1 interval had at least one bad P2 value ' ...
                'across all conditions. These P1 values and their corresponding P2 values across conditions were removed prior to computing AUC.'];
    warning('RPF:numericalIssue', warnText);
end

P1 = P1(f_bad == 0);
for i_cond = 1:R.info.nCond
    P2_f(i_cond, :) = P2(i_cond, f_bad == 0);
end
P2 = P2_f;


%% compue RPF AUC

for i_cond = 1:R.info.nCond
    AUC(i_cond)  = trapz( P1, P2(i_cond,:) );
end

% compute avg P2
P2_avg = AUC ./ (P1_UB - P1_LB);