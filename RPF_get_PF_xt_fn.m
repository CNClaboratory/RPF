function [xt_fn, xt_fn_inv] = RPF_get_PF_xt_fn(PF)
% [xt_fn, xt_fn_inv] = RPF_get_PF_xt_fn(PF)

logFunctions = RPF_get_PF_list('PFs_log');

if any( strcmp( func2str(PF), logFunctions ) )
    xt_fn     = @log10;
    xt_fn_inv = @(x)(10.^x);
else
    xt_fn     = @(x)(x);
    xt_fn_inv = @(x)(x);
end