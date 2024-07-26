function fit = RPF_fit_F_d(info, data)
% fit = RPF_fit_F_d(info, data)

fit = [];

for i_cond = 1:length(data)
    
    fit(i_cond).cond_label = info.cond_labels{i_cond};
    fit(i_cond).DV         = info.DV;
    fit(i_cond).fit_type   = info.fit_type;
    fit(i_cond).constrain  = info.constrain;
    fit(i_cond).PF         = info.PF;
    fit(i_cond).xt_fn      = info.xt_fn;
    fit(i_cond).xt_fn_inv  = info.xt_fn_inv;
    
    [fit(i_cond).params, fit(i_cond).logL] = RPF_PFML_d_fit(fit(i_cond).xt_fn(data(i_cond).x), data(i_cond), info);

    fit(i_cond).k = sum(info.paramsFree);
    fit(i_cond).n = sum( [data(i_cond).forMLE.nH, ...
                          data(i_cond).forMLE.nF, ...
                          data(i_cond).forMLE.nM, ...
                          data(i_cond).forMLE.nCR] ); 
end