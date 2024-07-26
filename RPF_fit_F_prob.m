function fit = RPF_fit_F_prob(info, data)
% fit = RPF_fit_F_prob(info, data)

fit  = [];

for i_cond = 1:length(data)
    
    fit(i_cond).cond_label = info.cond_labels{i_cond};
    fit(i_cond).DV         = info.DV;
    
    if isfield(info, 'DV_respCond')
        fit(i_cond).DV_respCond = info.DV_respCond;
    end
    
    fit(i_cond).fit_type   = info.fit_type;
    fit(i_cond).constrain  = info.constrain;
    fit(i_cond).PF         = info.PF;
    fit(i_cond).xt_fn      = info.xt_fn;
    fit(i_cond).xt_fn_inv  = info.xt_fn_inv;
    
    [fit(i_cond).params, fit(i_cond).logL] = PAL_PFML_Fit(fit(i_cond).xt_fn(data(i_cond).x), ...
                                                          data(i_cond).forMLE.nPos, data(i_cond).forMLE.nTot, ...
                                                          info.searchGrid, info.paramsFree, fit(i_cond).PF);

    fit(i_cond).k = sum(info.paramsFree);
    fit(i_cond).n = sum(data(i_cond).forMLE.nTot);
end