function fit = RPF_fit_Fx_prob(info, data, constrain, searchGrid)
% fit = RPF_fit_Fx_prob(info, data, constrain, searchGrid)

%% set default values

if ~exist('constrain', 'var')
    constrain = [];
end

if ~exist('searchGrid', 'var') || isempty(searchGrid)
    searchGrid = RPF_default_searchGrid(constrain, info.xt_fn);
end

paramsFree = RPF_get_paramsFree(constrain);


%% fit PF

fit  = [];

for i_cond = 1:length(data)
    
    fit(i_cond).cond_label = info.cond_labels{i_cond};
    fit(i_cond).DV         = info.DV;
    
    if isfield(info, 'DV_respCond')
        fit(i_cond).DV_respCond = info.DV_respCond;
    end
    
    fit(i_cond).fit_type   = info.fit_type;
    fit(i_cond).constrain  = constrain;
    fit(i_cond).PF         = info.PF;
    fit(i_cond).xt_fn      = info.xt_fn;
    fit(i_cond).xt_fn_inv  = info.xt_fn_inv;
    
    [fit(i_cond).params, fit(i_cond).logL] = PAL_PFML_Fit(fit(i_cond).xt_fn(data(i_cond).x), ...
                                                          data(i_cond).forMLE.nPos, data(i_cond).forMLE.nTot, ...
                                                          searchGrid, paramsFree, fit(i_cond).PF);

    fit(i_cond).k = sum(paramsFree);
    fit(i_cond).n = sum(data(i_cond).forMLE.nTot);
end