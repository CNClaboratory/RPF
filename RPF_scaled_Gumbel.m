function P = RPF_scaled_Gumbel(params, xt)

alpha = params(1);
beta  = params(2);
gamma = params(3);
omega = params(4);

P = gamma + (omega-gamma) .* (1 - exp(-1.*10.^(beta.*(xt-alpha))));