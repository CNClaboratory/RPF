function P = RPF_scaled_Weibull(params, x)

alpha = params(1);
beta  = params(2);
gamma = params(3);
omega = params(4);

P = gamma + (omega-gamma) .* (1 - exp(-1*(x./alpha).^beta));