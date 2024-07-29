function SSE = RPF_PFSSE_scaled_SSE(params, xt, data, PF)
% SSE = RPF_PFSSE_scaled_SSE(params, xt, data, PF)

P_fit = PF(params, xt);

SSE = sum( (data.P - P_fit).^2 );

if isnan(SSE)
    SSE = Inf; 
end