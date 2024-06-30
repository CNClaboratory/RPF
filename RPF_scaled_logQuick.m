function P = RPF_scaled_logQuick(params, x)

alpha = params(1);
beta  = params(2);
gamma = params(3);
omega = params(4);

P = gamma + (omega-gamma) .* (1 - 2.^(-1.*10.^(beta.*(x-alpha))));