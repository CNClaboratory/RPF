function [AUC, P2_avg] = RPF_AUC(R, P1_LB, P1_UB, P1_grain)
% [AUC, P2_avg] = RPF_AUC(R, P1_LB, P1_UB, P1_grain)
%
% Compute area under the RPF curve for each condition.
%
% INPUTS
% ------
% R        - RPF struct as output from RPF_get_R
% P1_LB    - lower bound on the P1 axis for computing RPF AUC. must be no
%            smaller than R.info.P1_LB_min
%            DEFAULT value is R.info.P1_LB_min
% P1_UB    - upper bound on the P1 axis for computing RPF AUC. must be no
%            larger than R.info.P1_UB_max
%            DEFAULT value is R.info.P1_UB_max
%
% P1_grain - RPF AUC is computed by numerical integration over [P1_LB :
%            P1_grain : P1_UB], so smaller values lead to more precise
%            estimates.
%            DEFAULT value is 1e-5.
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


%% compute RPF AUC

P1 = P1_LB : P1_grain : P1_UB;
P2 = RPF_eval_R(R, P1);

% % % exclude NaN values
% % f_nan = isnan(P2); % find NaN entries across all i_cond x P1 values
% % f_nan = sum(f_nan, 1); % combine NaN entries across i_cond
% % 
% % P1 = P1(~f_nan);
% % for i_cond = R.info.nCond
% %     P2_f_nan(i_cond, :) = P2(i_cond, ~f_nan);
% % end
% % P2 = P2_f_nan;

% compue AUC
for i_cond = 1:R.info.nCond
    AUC(i_cond)  = trapz( P1, P2(i_cond,:) );
end

% compute avg P2
P2_avg = AUC ./ (P1_UB - P1_LB);