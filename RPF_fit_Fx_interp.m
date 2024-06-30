function fit = RPF_fit_Fx_interp(info, data)
% fit = RPF_fit_Fx_interp(info, data)

%% 

fit  = [];

for i_cond = 1:length(data)
    
    fit(i_cond).cond_label = info.cond_labels{i_cond};
    fit(i_cond).DV         = info.DV;
    
    if isfield(info, 'DV_respCond')
        fit(i_cond).DV_respCond = info.DV_respCond;
    end
    
    fit(i_cond).fit_type   = info.fit_type;
    fit(i_cond).PF         = info.PF;
    fit(i_cond).xt_fn      = info.xt_fn;
    fit(i_cond).xt_fn_inv  = info.xt_fn_inv;
    
    xt = data(i_cond).xt;
    P  = data(i_cond).P;
    
    if info.append_xP_min
        xt = [info.xt_min, xt];
        P  = [info.P_min, P];
    end
    
    if info.append_xP_max
        xt = [xt, info.xt_max];
        P  = [P, info.P_max];
    end    
    
    fit(i_cond).append_xP_min    = info.append_xP_min;
    fit(i_cond).append_xP_max    = info.append_xP_max;
    fit(i_cond).params.xt     = xt;
    fit(i_cond).params.P      = P;
    fit(i_cond).params.interp_method = info.interp_method;
    
end