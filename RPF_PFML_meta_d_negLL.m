function negLL = RPF_PFML_meta_d_negLL(params, xt, data, PF)

%% get params

% get meta_d from PF
params_PF = params(1:4);
meta_d_PF = PF(params_PF, xt)';

% define meta_c so that meta_cprime == cprime in the data set
meta_c    = data.md_fit.c_prime' .* meta_d_PF;

% get meta_t2c from param list
nx           = length(xt);
nt2c_perResp = data.nRatings - 1;

switch data.DV_respCond
    case 'all'
        meta_t2c     = reshape(params(5:end), 2*nt2c_perResp, nx)';
        meta_t2c_rS1 = meta_t2c(:, 1:nt2c_perResp);
        meta_t2c_rS2 = meta_t2c(:, nt2c_perResp+1:end);
        
    case 'rS1'
        meta_t2c_rS1 = reshape(params(5:end), nt2c_perResp, nx)';
        meta_t2c_rS2 = repmat(1:nt2c_perResp, [nx, 1]); % dummy value
        
    case 'rS2'
        meta_t2c_rS1 = repmat(-nt2c_perResp:-1, [nx, 1]); % dummy value
        meta_t2c_rS2 = reshape(params(5:end), nt2c_perResp, nx)';
end


%% get data to be fit

switch data.DV_respCond
    case 'all'
        % fliplr for rS1 counts so that they're in SDT decision axis order
        nC_rS1 = fliplr( data.forMLE.nC_rS1 ); 
        nI_rS1 = fliplr( data.forMLE.nI_rS1 ); 
        
        nC_rS2 = data.forMLE.nC_rS2;
        nI_rS2 = data.forMLE.nI_rS2;
        
    case 'rS1'
        % fliplr for rS1 counts so that they're in SDT decision axis order
        nC_rS1 = fliplr( data.forMLE.nC_rS1 );
        nI_rS1 = fliplr( data.forMLE.nI_rS1 );

        % set rS2 counts to dummy value of 0
        nC_rS2 = zeros(size(nI_rS1));
        nI_rS2 = zeros(size(nC_rS1));
        
    case 'rS2'
        nC_rS2 = data.forMLE.nC_rS2;
        nI_rS2 = data.forMLE.nI_rS2;

        % set rS1 counts to dummy value of 0
        nC_rS1 = zeros(size(nI_rS2));
        nI_rS1 = zeros(size(nC_rS2));        
end

%% 

% define mean and SD of S1 and S2 distributions
S1mu = -meta_d_PF/2; S1sd = 1;
S2mu =  meta_d_PF/2; S2sd = 1;


% adjust so that the type 1 criterion is set at 0
% (this is just to work with optimization toolbox constraints...
%  to simplify defining the upper and lower bounds of type 2 criteria)
S1mu = S1mu - meta_c;
S2mu = S2mu - meta_c;

t1c = 0;


%% get type 2 probabilities according to the fit

% response-conditional areas used for normalization
C_area_rS1 = normcdf(t1c, S1mu, S1sd);
I_area_rS1 = normcdf(t1c, S2mu, S2sd);

C_area_rS2 = 1-normcdf(t1c, S2mu, S2sd);
I_area_rS2 = 1-normcdf(t1c, S1mu, S1sd);

% t2cx_rS1 and t2cx_rS2 are (nx x nt2c) matrices where rows are levels of x 
% and columns are the criteria used in the meta-d' model (with flanking values
% of +/- Inf to make computation easier)
t2cx_rS1 = [-Inf(nx,1),     meta_t2c_rS1, t1c*ones(nx,1)];
t2cx_rS2 = [t1c*ones(nx,1), meta_t2c_rS2, Inf(nx,1)];

    
% compute model probability of each type 2 outcome
for i_r = 1:data.nRatings

    prC_rS1(:, i_r) = ( normcdf(t2cx_rS1(:, i_r+1),S1mu,S1sd) - normcdf(t2cx_rS1(:, i_r),S1mu,S1sd) ) ./ C_area_rS1;
    prI_rS1(:, i_r) = ( normcdf(t2cx_rS1(:, i_r+1),S2mu,S2sd) - normcdf(t2cx_rS1(:, i_r),S2mu,S2sd) ) ./ I_area_rS1;

    prC_rS2(:, i_r) = ( (1-normcdf(t2cx_rS2(:, i_r),S2mu,S2sd)) - (1-normcdf(t2cx_rS2(:, i_r+1),S2mu,S2sd)) ) ./ C_area_rS2;
    prI_rS2(:, i_r) = ( (1-normcdf(t2cx_rS2(:, i_r),S1mu,S1sd)) - (1-normcdf(t2cx_rS2(:, i_r+1),S1mu,S1sd)) ) ./ I_area_rS2;

end

% adjust for zero probabilities to avoid NaN or Inf logL
prC_rS1 = adjustForZeros(prC_rS1);
prI_rS1 = adjustForZeros(prI_rS1);
prC_rS2 = adjustForZeros(prC_rS2);
prI_rS2 = adjustForZeros(prI_rS2);


% compute logL
logL = sum( nC_rS1 .* log(prC_rS1) + ...
            nI_rS1 .* log(prI_rS1) + ...
            nC_rS2 .* log(prC_rS2) + ...
            nI_rS2 .* log(prI_rS2),  ...
            "all" ); 

negLL = -logL;

if isnan(negLL)
    negLL = Inf; 
end

end


%% adjust for zeros in model probabilities
%  by adding a small amount to each zero cell and then renormalizing so
%  probabilities still add to 1

function p_adj = adjustForZeros(p)

if any(p(:)==0)
    p(p==0) = 1e-10;
    p_adj   = p ./ sum(p, 2);
else
    p_adj   = p;
end

end