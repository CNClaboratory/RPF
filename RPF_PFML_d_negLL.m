function negLL = RPF_PFML_d_negLL(params, xt, data, PF)
% negLL = RPF_PFML_d_negLL(params, xt, data, PF)

% get d' from PF fit
d_fit = PF(params, xt);

% use d' from PF fit with c from the trial data to solve for HR and FAR
% corresponding to the PF fit
zHR_fit  =  d_fit/2 - data.SDT.type1.c;
zFAR_fit = -d_fit/2 - data.SDT.type1.c;

HR_fit  = normcdf(zHR_fit);
FAR_fit = normcdf(zFAR_fit);

MR_fit  = 1-HR_fit;
CRR_fit = 1-FAR_fit;


% compute logL
logL = sum( data.forMLE.nH  .* log(HR_fit) + ...
            data.forMLE.nM  .* log(MR_fit) + ...
            data.forMLE.nF  .* log(FAR_fit) + ...
            data.forMLE.nCR .* log(CRR_fit) ); 

negLL = -logL;

if isnan(negLL)
    negLL = Inf; 
end