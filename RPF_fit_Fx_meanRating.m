function fit = RPF_fit_Fx_meanRating(info, data, constrain, searchGrid)
% fit = RPF_fit_Fx_meanRating(info, data, constrain, searchGrid)

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
    
    for i_rating = 2:info.nRatings

        % fit p(high rating) separately for each rating threshold and save
        % each fit in its own fit(i_cond).pHighRating(i_rating-1) struct
        fit(i_cond).pHighRating(i_rating-1).constrain = constrain;
        fit(i_cond).pHighRating(i_rating-1).PF        = info.PF_pHighRating;
        fit(i_cond).pHighRating(i_rating-1).xt_fn     = info.xt_fn;
        
        xt   = fit(i_cond).pHighRating(i_rating-1).xt_fn( data(i_cond).x );
        nPos = data(i_cond).pHighRating(i_rating-1).forMLE.nPos;
        nTot = data(i_cond).pHighRating(i_rating-1).forMLE.nTot;
        PF   = fit(i_cond).pHighRating(i_rating-1).PF;

        [params, logL] = PAL_PFML_Fit(xt, nPos, nTot, searchGrid, paramsFree, PF);

        fit(i_cond).pHighRating(i_rating-1).params = params;
        fit(i_cond).pHighRating(i_rating-1).logL   = logL;
        
        fit(i_cond).pHighRating(i_rating-1).k = sum(paramsFree);
        fit(i_cond).pHighRating(i_rating-1).n = sum(data(i_cond).pHighRating(i_rating-1).forMLE.nTot);
        
        % reproduce parameter values in the standardized fit(i_cond).params field
        fit(i_cond).params.value(i_rating-1, :) = fit(i_cond).pHighRating(i_rating-1).params;
        fit(i_cond).params.PF = info.PF_pHighRating;
        fit(i_cond).PF        = info.PF;
        fit(i_cond).xt_fn     = info.xt_fn;
        fit(i_cond).xt_fn_inv = info.xt_fn_inv;
    end
end