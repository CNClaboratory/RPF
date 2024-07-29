function [x, xt, invMethod] = RPF_eval_F_inv(F, P, invMethod)
% [x, xt, invMethod] = RPF_eval_F_inv(F, P, invMethod)
% 
% Evaluate the inverse psychometric functions xt = F^-1(P) for each condition.
%
% INPUTS
% ------
% F         - the F struct. see RPF_guide('F')
% P         - an array of P values at which to evaluate F^-1. 
%             P may be of size [1, nP] or [nCond, nP]. if size [1, nP], then
%             every condition is evaluated at these values of P. if size [nCond,
%             nP], then the output x(i_cond, :) is evaluated at P(i_cond, :)
%             for all conditions i_cond.
% invMethod - method for computing the inverse. if 'analytical', an analytical
%             solution will be employed if possible. if 'numerical', a 
%             numerical approach will be employed.
%           * DEFAULT = 'analytical' if available, 'numerical' otherwise
% 
% OUTPUTS
% -------
% x         - a matrix of size [nCond, length(P)] that contains x for each
%             condition
% xt        - same as x, but expressed in terms of the x transform
% invMethod - the method used to solve for x. may be 'analytical' or 'numerical'


%% check inputs

P_at_x_min = RPF_eval_F(F, F.info.x_min);
P_at_x_max = RPF_eval_F(F, F.info.x_max);

if any(min(P) < P_at_x_min) || any(max(P) > P_at_x_max)
    warnText = ['In the input F struct, \n' ...
                '- P at x min = ' regexprep(num2str(P_at_x_min', 2),   '\s+', ', ') '\n' ...
                '- P at x max = ' regexprep(num2str(P_at_x_max', 2),   '\s+', ', ') '\n\n' ...
                'Some of the input values for P exceed these bounds, which may cause ' ...
                'numerical issues such as imaginary solutions for x.'];
    warning('RPF:invalidInput', warnText);
end

%% determine inversion method

PFs_inverse = RPF_get_PF_list('PFs_inverse');

if any(strcmp(func2str(F.fit(1).PF), PFs_inverse)) && (~exist('invMethod','var') || isempty(invMethod)) 
    invMethod = 'analytical';
else
    invMethod = 'numerical';
end


%% compute the inverse

switch invMethod
    
    % the analytical method uses the 'Inverse' option of the PF function, as
    % available in Palamedes toolbox functions
    case 'analytical'
        for i_cond = 1:F.info.nCond
            if size(P,1) == 1
                xt(i_cond,:) = F.fit(i_cond).PF( F.fit(i_cond).params, P, 'Inverse' );
            elseif size(P,1) == F.info.nCond
                xt(i_cond,:) = F.fit(i_cond).PF( F.fit(i_cond).params, P(i_cond,:), 'Inverse' );
            end            
        end
        
        x = F.fit(1).xt_fn_inv( xt );

    % the numerical method computes Pi = F(xti) for finely grained xi values from 
    % x_min to x_max, then interpolates over (Pi, xti) to estimate x from P
    case 'numerical'

        x_grain = 1e-5;
        xi  = F.info.x_min : x_grain : F.info.x_max;
        xti = F.fit(1).xt_fn( xi );
        
        for i_cond = 1:F.info.nCond
            
            % compute Pi = F(xti)
            Pi = F.fit(i_cond).PF( F.fit(i_cond).params, xti );

            % interp1 requires unique sample points, and Px may be so
            % closely spaced that some entries fail to register as unique,
            % so we need to ensure uniqueness
            [Pi_unique, ind_unique] = unique(Pi);
            xti_unique              = xti(ind_unique);
            
            % interpolate over (Pi, xx) to estimate x at P
            xt(i_cond,:) = interp1(Pi_unique, xti_unique, P);
        end

        x = F.fit(1).xt_fn_inv( xt );
end