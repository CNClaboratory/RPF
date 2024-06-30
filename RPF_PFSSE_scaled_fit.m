function [params, SSE] = RPF_PFSSE_scaled_fit(xt, data, searchGrid, paramsFree, PF, info)
% [params, SSE] = RPF_PFSSE_scaled_fit(xt, data, searchGrid, paramsFree, PF, info)

%% set up constraints for MLE estimation

A = [];
b = [];

LB = [info.xt_fn(0),     0,   0, info.P_min];
UB = [info.xt_fn(Inf), Inf, Inf, info.P_max];

paramNames = {'alpha', 'beta', 'gamma' 'omega'};
for i = 1:length(paramsFree)
    if ~paramsFree(i)
        LB(i) = eval(['searchGrid.' paramNames{i} ';']);
        UB(i) = LB(i);
    end
end


%% initial guess

d = data.P;

best_SSE = Inf;
for i_alpha = 1:length(searchGrid.alpha)
    for i_beta = 1:length(searchGrid.beta)
        for i_gamma = 1:length(searchGrid.gamma)
            for i_omega = 1:length(searchGrid.omega)

                params  = [searchGrid.alpha(i_alpha), searchGrid.beta(i_beta), searchGrid.gamma(i_gamma), searchGrid.omega(i_omega)];

                SSE = RPF_PFSSE_scaled_SSE(params, xt, data, PF);
                if SSE < best_SSE
                    best_SSE = SSE;
                    guess    = params;
                end

            end
        end
    end
end


%% fit

op = optimset(@fmincon);
op = optimset(op,'MaxFunEvals',100000);

[params, SSE] = fmincon(@(params)RPF_PFSSE_scaled_SSE(params, xt, data, PF), guess, A, b, [], [], LB, UB, [], op);
