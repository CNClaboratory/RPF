function Pq = RPF_interp_PF(params, xtq)
% Pq = RPF_interp_PF(params, xtq)

if isfield(params, 'interp_method')
    interp_method = params.interp_method;
else
    interp_method = 'linear';
end

if ~strcmp(interp_method,'isotonic')
    Pq = interp1(params.xt, params.P, xtq, interp_method);
else
    % Do isotonic regression and then interpolate that across params.xt
    % Force the final interpolation step to be linear in this case.
    y_isotonic = RPF_interp_isotonic(params.xt,params.P);
    Pq = interp1(params.xt, y_isotonic, xtq, 'linear');
end