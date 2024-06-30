function Pq = RPF_interp_Fx(params, xtq)

if isfield(params, 'interp_method')
    interp_method = params.interp_method;
else
    interp_method = 'linear';
end

Pq = interp1(params.xt, params.P, xtq, interp_method);