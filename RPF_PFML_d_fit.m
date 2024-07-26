function [params, logL] = RPF_PFML_d_fit(xt, data, info)
% [params, logL] = RPF_PFML_d_fit(xt, data, info)

%% unpack

searchGrid = info.searchGrid;
PF         = info.PF;

%% set up constraints for MLE estimation

A = [];
b = [];

LB = [info.xt_fn(0),     0,   0, info.P_min];
UB = [info.xt_fn(Inf), Inf, Inf, info.P_max];

paramNames = {'alpha', 'beta', 'gamma' 'omega'};
for i = 1:length(info.paramsFree)
    if ~info.paramsFree(i)
        LB(i) = eval(['searchGrid.' paramNames{i} ';']);
        UB(i) = LB(i);
    end
end


%% initial guess

best_negLL = Inf;
for i_alpha = 1:length(searchGrid.alpha)
    for i_beta = 1:length(searchGrid.beta)
        for i_gamma = 1:length(searchGrid.gamma)
            for i_omega = 1:length(searchGrid.omega)

                params  = [searchGrid.alpha(i_alpha), searchGrid.beta(i_beta), searchGrid.gamma(i_gamma), searchGrid.omega(i_omega)];

                negLL = RPF_PFML_d_negLL(params, xt, data, PF);
                
                if negLL < best_negLL
                    best_negLL = negLL;
                    guess      = params;
                end

            end
        end
    end
end


%% fit

op = optimset(@fmincon);
op = optimset(op,'MaxFunEvals',100000);

[params, negLL] = fmincon(@(params)RPF_PFML_d_negLL(params, xt, data, PF), guess, A, b, [], [], LB, UB, [], op);

logL = -negLL;

end