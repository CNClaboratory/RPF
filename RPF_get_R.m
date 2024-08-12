function R = RPF_get_R(F1, F2, P1_LB, P1_UB)
% R = RPF_get_R(F1, F2)
%
% Create a struct for setting up RPF analysis and plotting.
%
% INPUTS
% ------
% F1    - an F struct holding details for the psychometric function P1 = F1(x).
%         see RPF_guide('F')
% F2    - same as F1, but for the function P2 = F2(x)
% P1_LB - optional input specifying the lower bound of P1 for computing RPF
%         AUC. Default value is the minimum possible, as stored in the
%         output R.info.P1_LB_min. Note that if P1_LB < R.info.P1_LB_min, 
%         P1_LB will be automatically set equal to R.info.P1_LB_min.
% P1_UB - optional input specifying the upper bound of P1 for computing RPF
%         AUC. Default value is the maximum possible, as stored in the
%         output R.info.P1_UB_max. Note that if P1_UB > R.info.P1_UB_max, 
%         P1_UB will be automatically set equal to R.info.P1_UB_max.
% 
% OUTPUTS
% -------
% R - the R struct. see RPF_guide('R')


%% check inputs

if strcmp('RPF_interp_PF', func2str(F1.fit(1).PF)) && ~strcmp('RPF_interp_PF', func2str(F2.fit(1).PF))
    error('RPF:invalidOption', ['\nThe following settings in the F1 and F2 structs are incompatible:\n' ...
                                '- F1.fit(1).PF is set to ''' func2str(F1.fit(1).PF) '''\n' ... 
                                '- F2.fit(1).PF is set to ''' func2str(F2.fit(1).PF) '''\n' ... 
                                'If F1(x) is estimated by interpolation, then F2(x) must be as well.']);                     
end


%% define R.F1 and R.F2

R.F1       = F1;
R.F1.F_ind = 1;

R.F2       = F2;
R.F2.F_ind = 2;

%% define R.info

R.info.PF_type = 'R(P1)';

if all( strcmp('PAL_Weibull', {func2str(F1.info.PF), func2str(F2.info.PF)}) )
    R.info.PF = @RPF_Weibull_RPF;

elseif all( strcmp('RPF_interp_PF', {func2str(F1.info.PF), func2str(F2.info.PF)}) )
    R.info.PF = @RPF_interp_RPF;

else
    R.info.PF = [];
end

R.info.P1_label    = F1.info.P_label;
R.info.P2_label    = F2.info.P_label;
R.info.cond_labels = F1.info.cond_labels;
R.info.cond_vals   = F1.info.cond_vals;
R.info.nCond       = F1.info.nCond;
R.info.x_vals      = F1.info.x_vals;

R.info.x_min = max( [F1.info.x_min, F2.info.x_min] );
R.info.x_max = min( [F1.info.x_max, F2.info.x_max] );

% P1, P2, AUC min/max values bases on min/max x
for i_cond = 1:length(F1.info.cond_vals)
    R.info.P1_at_x_min(i_cond) = R.F1.fit(i_cond).PF( R.F1.fit(i_cond).params, R.F1.fit(i_cond).xt_fn(R.info.x_min) );
    R.info.P1_at_x_max(i_cond) = R.F1.fit(i_cond).PF( R.F1.fit(i_cond).params, R.F1.fit(i_cond).xt_fn(R.info.x_max) );

    R.info.P2_at_x_min(i_cond) = R.F2.fit(i_cond).PF( R.F2.fit(i_cond).params, R.F2.fit(i_cond).xt_fn(R.info.x_min) );
    R.info.P2_at_x_max(i_cond) = R.F2.fit(i_cond).PF( R.F2.fit(i_cond).params, R.F2.fit(i_cond).xt_fn(R.info.x_max) );
end

R.info.max_P1_at_x_min = max( R.info.P1_at_x_min );
R.info.min_P1_at_x_max = min( R.info.P1_at_x_max );


%% define R.fit

for i_cond = 1:R.info.nCond
        
    R.fit(i_cond).PF = R.info.PF;    
    
    % handle case where RPF is estimated entirely via interpolation
    if isa(R.info.PF, 'function_handle') && strcmp('RPF_interp_RPF', func2str(R.fit(i_cond).PF))

        % get P1 and P2 for current condition
        P1 = F1.fit(i_cond).params.P;
        P2 = F2.fit(i_cond).params.P;

        % sort both in ascending P1 order
        [P1_sorted, sort_ind] = sort(P1);
        P2_sorted = P2(sort_ind);

        % average at duplicate P1 values
        i = 1;
        j = 1;
        P1_sorted_unique = [];
        P2_sorted_unique = [];
        while i <= length(P1_sorted)

            f = find( P1_sorted == P1_sorted(i) );

            P1_sorted_unique(j) = P1_sorted(i);
            P2_sorted_unique(j) = mean( P2_sorted(f) );

            i = max(f) + 1;
            j = j + 1;

        end        
        
        R.fit(i_cond).params.P1_sorted_unique = P1_sorted_unique;
        R.fit(i_cond).params.P2_sorted_unique = P2_sorted_unique;
        R.fit(i_cond).params.interp_method    = F2.fit(i_cond).params.interp_method;
        
        R.info.P1_data_min(i_cond) = min(P1_sorted_unique);
        R.info.P1_data_max(i_cond) = max(P1_sorted_unique);
        
    % handle all other cases
    else
        R.fit(i_cond).params.F1 = F1.fit(i_cond).params;
        R.fit(i_cond).params.F2 = F2.fit(i_cond).params;
    end
end


%% define lower and upper P1 bounds for computing AUC

% find min LB and max UB
if isa(R.info.PF, 'function_handle') && strcmp('RPF_interp_RPF', func2str(R.info.PF))
    R.info.max_P1_data_min = max( R.info.P1_data_min );
    R.info.min_P1_data_max = min( R.info.P1_data_max );
    
    R.info.P1_LB_min = R.info.max_P1_data_min;
    R.info.P1_UB_max = R.info.min_P1_data_max;
    
else
    R.info.P1_LB_min = R.info.max_P1_at_x_min;
    R.info.P1_UB_max = R.info.min_P1_at_x_max;    
end


% set LB and UB used for AUC analysis and plotting
if ~exist('P1_LB', 'var') || isempty(P1_LB)
    R.info.P1_LB = R.info.P1_LB_min;

elseif P1_LB < R.info.P1_LB_min || P1_LB >= R.info.P1_UB_max
    R.info.P1_LB = R.info.P1_LB_min;

    warnText = ['R.info.P1_LB has been set to R.info.P1_LB_min due to missing or bad input value for P1_LB.\n']; 
    warning('RPF:inputOverride', warnText);

else
    R.info.P1_LB = P1_LB;
end

if ~exist('P1_UB', 'var') || isempty(P1_UB)
    R.info.P1_UB = R.info.P1_UB_max;
    
elseif P1_UB <= R.info.P1_LB_min || P1_UB > R.info.P1_UB_max || P1_UB <= R.info.P1_LB
    R.info.P1_UB = R.info.P1_UB_max;

    warnText = ['R.info.P1_UB has been set to R.info.P1_UB_max due to missing or bad input value for P1_UB.\n']; 
    warning('RPF:inputOverride', warnText);

else
    R.info.P1_UB = P1_UB;
end


%% add AUC analysis to R.fit

[AUC, P2_avg] = RPF_AUC(R);

for i_cond = 1:length(F1.info.cond_vals)
    R.fit(i_cond).P1_at_x_min = R.info.P1_at_x_min(i_cond);
    R.fit(i_cond).P1_at_x_max = R.info.P1_at_x_max(i_cond);

    R.fit(i_cond).P1_LB  = R.info.P1_LB;
    R.fit(i_cond).PU_LB  = R.info.P1_UB;
    
    R.fit(i_cond).AUC    = AUC(i_cond);
    R.fit(i_cond).P2_avg = P2_avg(i_cond);
end