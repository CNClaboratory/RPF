function [params, logL] = RPF_PFML_meta_d_fit(xt, data, searchGrid, paramsFree, PF, info)
% [params, logL] = RPF_PFML_meta_d_fit(xt, data, searchGrid, paramsFree, PF, info)

%% set up constraints for MLE estimation

n_t2c_perResp_perX = data.nRatings - 1;
nx = length(xt);

%% set LB and UB for PF parameters

LB_PF = [info.xt_fn(0),     0,   0, info.P_min];
UB_PF = [info.xt_fn(Inf), Inf, Inf, info.P_max];

paramNames = {'alpha', 'beta', 'gamma' 'omega'};
for i = 1:length(paramsFree)
    if ~paramsFree(i)
        LB_PF(i) = eval(['searchGrid.' paramNames{i} ';']);
        UB_PF(i) = LB_PF(i);
    end
end


%% set up LB and UB for type 2 criteria

% first set of t2c correspond to resp="S1", second to resp="S2"
% these have upper and lower bounds of zero, respectively, because in the
% meta-SDT model used to compute likelihood, t1c is defined to be 0
LB_t2c_rS1_perX = -20*ones(1, n_t2c_perResp_perX);
UB_t2c_rS1_perX = zeros(1, n_t2c_perResp_perX);

LB_t2c_rS2_perX = zeros(1, n_t2c_perResp_perX);
UB_t2c_rS2_perX = 20*ones(1, n_t2c_perResp_perX);

switch data.DV_respCond
    case 'all'
        LB_t2c_perX = [LB_t2c_rS1_perX, LB_t2c_rS2_perX];
        UB_t2c_perX = [UB_t2c_rS1_perX, UB_t2c_rS2_perX];

    case 'rS1'
        LB_t2c_perX = LB_t2c_rS1_perX;
        UB_t2c_perX = UB_t2c_rS1_perX;
        
    case 'rS2'
        LB_t2c_perX = LB_t2c_rS2_perX;
        UB_t2c_perX = UB_t2c_rS2_perX;
end

% tile LB and UB over x
LB_t2c = repmat(LB_t2c_perX, 1, nx);
UB_t2c = repmat(UB_t2c_perX, 1, nx);


%% define final set of LB and UB

LB = [LB_PF, LB_t2c];
UB = [UB_PF, UB_t2c];


%% set linear constraints for type 2 criteria

%%% define linear constraints on t2c for each level of response and x

% constrain type 2 criteria values such that t2c(i) is always <= t2c(i+1)
% want t2c(i) <= t2c(i+1) 
% -->  t2c(i) <= t2c(i+1) - b (i.e. very small deviation b from equality) 
% -->  t2c(i) - t2c(i+1) <= b

A_t2c_perResp_perX = [];

for i_t2c = 1 : n_t2c_perResp_perX-1
    A_t2c_perResp_perX(end+1, [i_t2c, i_t2c+1]) = [1 -1];
end


%%% tile over response to get linear constraints on t2c for each level of x
switch data.DV_respCond
    case 'all'
        A_t2c_perX = A_t2c_perResp_perX;

        i_row1 = size(A_t2c_perX, 1) + 1;
        i_col1 = size(A_t2c_perX, 2) + 1;
        i_row2 = i_row1 + size(A_t2c_perResp_perX, 1) - 1;
        i_col2 = i_col1 + size(A_t2c_perResp_perX, 2) - 1;

        A_t2c_perX( i_row1 : i_row2, i_col1 : i_col2 ) = A_t2c_perResp_perX;

    case {'rS1', 'rS2'}
        A_t2c_perX = A_t2c_perResp_perX;
end        
        
%%% tile over x to get all linear constraints on t2c

A_t2c = A_t2c_perX;

for i_x = 1 : nx-1
        
    i_row1 = size(A_t2c, 1) + 1;
    i_col1 = size(A_t2c, 2) + 1;
    i_row2 = i_row1 + size(A_t2c_perX, 1) - 1;
    i_col2 = i_col1 + size(A_t2c_perX, 2) - 1;

    A_t2c( i_row1 : i_row2, i_col1 : i_col2 ) = A_t2c_perX;

end

%%% append linear constraints for the 4 PF params to get final linear
%%% constraint matrix A

if isempty(A_t2c)
    A = [];
    b = [];
    
else
    A_PF = zeros( size(A_t2c, 1), 4 );
    A    = [A_PF, A_t2c];
    b    = -1e-5 * ones(size(A,1), 1);
end


%% initial guess

%%% use t2c from meta-d' fits as initial guess for t2c in PF model

% retrieve t2c from meta-d' fits
switch data.DV_respCond
    case 'all'
        params_t2c = [data.md_fit.meta_t2c_rS1, data.md_fit.meta_t2c_rS2];
        nCol       = nx * (2*data.nRatings-2);
        
    case 'rS1'
        params_t2c = data.md_fit.meta_t2c_rS1;
        nCol       = nx * (data.nRatings-1);

    case 'rS2'
        params_t2c = data.md_fit.meta_t2c_rS2;
        nCol       = nx * (data.nRatings-1);

end

params_t2c_adj = params_t2c - data.md_fit.meta_t1c'; % shift t2c such that meta_t1c = 0 (for convenience of model fitting)
params_t2c_adj = reshape(params_t2c_adj', 1, nCol);  % reshape to a row vector for use with @fmincon


best_neglogL = Inf;

for i_alpha = 1:length(searchGrid.alpha)
    for i_beta = 1:length(searchGrid.beta)
        for i_gamma = 1:length(searchGrid.gamma)
            for i_omega = 1:length(searchGrid.omega)

                params_PF = [searchGrid.alpha(i_alpha), searchGrid.beta(i_beta), searchGrid.gamma(i_gamma), searchGrid.omega(i_omega)];
                params    = [params_PF, params_t2c_adj];
                
                negLL     = RPF_PFML_meta_d_negLL(params, xt, data, PF);
                
                if negLL < best_neglogL
                    best_neglogL = negLL;
                    guess        = params;
                end

            end
        end
    end
end


%% fit

op = optimset(@fmincon);
op = optimset(op,'MaxFunEvals',100000);

[params, negLL] = fmincon(@(params)RPF_PFML_meta_d_negLL(params, xt, data, PF), guess, A, b, [], [], LB, UB, [], op);

logL = -negLL;

end