function fit = RPF_fit_F_meta_d(info, data)
% fit = RPF_fit_F_meta_d(info, data)

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

    % perform the fit
    [fit(i_cond).params_all, fit(i_cond).logL] = RPF_PFML_meta_d_fit(data(i_cond).xt, data(i_cond), info);

    % unpack parameters
    fit(i_cond).params  = fit(i_cond).params_all(1:4);
    fit(i_cond).meta_d  = fit(i_cond).PF( fit(i_cond).params, data(i_cond).xt );
    fit(i_cond).c_prime = data(i_cond).md_fit.c_prime;
    fit(i_cond).meta_c  = data(i_cond).md_fit.c_prime .* fit(i_cond).meta_d;

    % format meta_t2c into an (nx, nt2c) matrix
    nx           = length(data(i_cond).xt);
    nt2c_perResp = data(i_cond).nRatings - 1;    
    
    switch data(i_cond).DV_respCond
        case 'all'
            nt2c = 2*nt2c_perResp;
        case {'rS1', 'rS2'}
            nt2c =   nt2c_perResp;
    end
    
    meta_t2c = reshape(fit(i_cond).params_all(5:end), nt2c, nx)';
    fit(i_cond).meta_t2c_unadj = meta_t2c;    

    % adjust t2c so they're centered around meta_c instead of 0
    fit(i_cond).meta_t2c = meta_t2c + fit(i_cond).meta_c';    
    
    fit(i_cond).k     = sum(info.paramsFree);
    fit(i_cond).k_all = sum(info.paramsFree) + numel(meta_t2c);
    
    switch data(i_cond).DV_respCond
        case 'all'
            fit(i_cond).n = sum( [data(i_cond).forMLE.nC_rS1(:); ...
                                  data(i_cond).forMLE.nI_rS1(:); ...
                                  data(i_cond).forMLE.nC_rS2(:); ...
                                  data(i_cond).forMLE.nI_rS2(:)] ); 
        case 'rS1'
            fit(i_cond).n = sum( [data(i_cond).forMLE.nC_rS1(:); ...
                                  data(i_cond).forMLE.nI_rS1(:)] ); 

        case 'rS2'
            fit(i_cond).n = sum( [data(i_cond).forMLE.nC_rS2(:); ...
                                  data(i_cond).forMLE.nI_rS2(:)] ); 

    end

end