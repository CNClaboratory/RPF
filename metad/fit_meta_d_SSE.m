function fit = fit_meta_d_SSE(obs_HR2_rS1, obs_FAR2_rS1, obs_HR2_rS2, obs_FAR2_rS2, cprime, s, d_min, d_max, d_grain)
% fit = fit_metad_SSE(obs_HR2_rS1, obs_FAR2_rS1, obs_HR2_rS2, obs_FAR2_rS2,
%                     cprime, s, d_min, d_max, d_grain)
%
% Given response-conditional type 2 hit rates and type 2 false alarm rates,
% as well as the empirically estimated relative criterion cprime = c / d', 
% use a signal detection theory model to estimate meta-d', 
% the value of d' that would have been expected to generate the observed
% type 2 data.
%
% Estimation is done by testing different values for meta-d' to see what
% value gives the best fit to the observed data (best fit = minimizes sum
% squared error between observed and expected type 2 HR and type 2 FAR).
%
%
% required inputs
% ---------------
% obs_HR2_rS1, obs_FAR2_rS1 :
% Arrays of observed type 2 hit rate (p(high confidence|correct "S1" response)) 
% and type 2 false alarm rate (p(high confidence|incorrect "S1" response)). 
% The size of each array is N-1, where N is the number of options for
% rating confidence. So for instance, if you use a confidence scale with
% 4 levels of confidence, these arrays should contain 3 elements each. 
% The i_th element corresponds to the type 2 HR and type 2 FAR found by
% considering all confidence ratings of i+1 or higher to be "high
% confidence". 
% The i_th element of obs_HR2_rS1 must correspond to the i_th element of
% obs_FAR2_rS1. Otherwise, ordering of the data is not important.
%
% obs_HR2_rS2, obs_FAR2_rS2 : same as above, for "S2" responses
%
% cprime : 
% The relative type 1 criterion. 
%
% c' = c / d', where
%
% d' = z(type 1 HR) - z(type 1 FAR)
% c = -.5 * [z(type 1 HR) + z(type 1 FAR)]
%
% and z is the inverse of the normal cumulative distribution function.
%
% If s != 1, specify c' in units of the S1 distribution, as follows.
%
% d' = (1/s)*z(type 1 HR) - z(type 1 FAR)
% c = [ -1 / (1+s) ] * [z(type 1 HR) + z(type 1 FAR)]
%
% optional inputs
% ---------------
% s :
% The ratio of the standard deviations of the evidence distributions for
% stimulus classes S1 and S2. Can be estimated from rating data. 
% If unspecified, s = 1
%
% d_min :
% The minimimum value for meta-d' that will be tested.
% If unspecified, d_min = -5
%
% d_max : 
% The maximum value for meta-d' that will be tested.
% If unspecified, d_max = 5
%
% d_grain : 
% The step size used in testing values of meta-d'.
% If unspecified, d_grain = .01
%
%
% output
% ------
% fit.meta_d :
% meta_d' value that minimizes the SSE between observed and expected type 2
% data. If s != 1, meta_d' is specified in units of the S1 distribution.
%
% fit.meta_c :
% The value of type 1 criterion c used in conjunction with meta_d'. 
% meta_c / meta_d = cprime, the constant type 1 criterion specified in the
% input. If s != 1, meta-c is specified in units of the S1 distribution.
%
% fit.s :
% The value of s used in the type 2 data fitting, where s = sd(S1) / sd(S2)
%
% fit.t2c_rS1 :
% Values for the type 2 criteria that, along with meta-d' and c', provide
% the best fit for type 2 data for "S1" responses
%
% fit.t2c_rS2 :
% Likewise, for "S2" responses
%
% fit.SSE :
% Sum of squared errors between observed and expected type 2 data
%
% fit.est_HR2_rS1 :
% The type 2 hit rates for "S1" responses expected from meta_d, meta_c, s,
% and t2c_rS1
%
% fit.obs_HR2_rS1 : 
% Empirically observed type 2 hit rates for "S1" responses
%
% fit.est_FAR2_rS1, fit.obs_FAR2_rS1, fit.est_HR2_rS2, ...
% Likewise as above, for expected and observed type 2 FAR for "S1" 
% responses and type 2 HR and type 2 FAR for "S2" responses 

% 9/7/10 - bm - wrote it


%% initialize optional inputs
if ~exist('s','var') || isempty(s), s=1; end
if ~exist('d_min','var') || isempty(d_min), d_min = -5; end
if ~exist('d_max','var') || isempty(d_max), d_max = 5; end
if ~exist('d_grain','var')  || isempty(d_grain), d_grain = .01; end



%% initialize analysis
nRatings = length(obs_HR2_rS1);

ds = d_min : d_grain : d_max;

SSEmin = Inf;
meta_d = [];
meta_c = [];
t2c_rS1 = [];
t2c_rS2 = [];
est_HR2_rS1 = [];
est_FAR2_rS1 = [];
est_HR2_rS2 = [];
est_FAR2_rS2 = [];


%% search for meta-d' that minimizes type 2 SSE
for i=1:length(ds)
        
    % initialize parameters for current level of meta-d'
    d = ds(i);
    c = cprime * d;

    S1mu = -d/2;
    S2mu = d/2;
    S1sd = 1;
    S2sd = 1/s;
    
    x = S1mu - 5*max([S1sd S2sd]) : .001 : S2mu + 5*max([S1sd S2sd]);
    [diff c_ind] = min(abs(x-c));

    HRs = 1-normcdf(x,S2mu,S2sd);
    FARs = 1-normcdf(x,S1mu,S1sd);




    % fit type 2 data for S1 responses
    est_HR2s_rS1 = (1-FARs(1:c_ind)) / (1-FARs(c_ind));
    est_FAR2s_rS1 = (1-HRs(1:c_ind)) / (1-HRs(c_ind));

    for n=1:nRatings
        SSE = (est_HR2s_rS1 - obs_HR2_rS1(n)).^2 + (est_FAR2s_rS1 - obs_FAR2_rS1(n)).^2;
        [SSE_rS1(n) rS1_ind(n)] = min(SSE);
    end



    % fit type 2 data for S2 responses
    est_HR2s_rS2 = HRs(c_ind:end) / HRs(c_ind);
    est_FAR2s_rS2 = FARs(c_ind:end) / FARs(c_ind);

    for n=1:nRatings
        SSE = (est_HR2s_rS2 - obs_HR2_rS2(n)).^2 + (est_FAR2s_rS2 - obs_FAR2_rS2(n)).^2;
        [SSE_rS2(n) rS2_ind(n)] = min(SSE);
    end



    % update analysis
    SSEtot = sum(SSE_rS1) + sum(SSE_rS2);
    if SSEtot < SSEmin
        SSEmin = SSEtot;
        meta_d = d;
        meta_c = c;
        t2c_rS1 = x(rS1_ind);
        t2c_rS2 = x(c_ind + rS2_ind - 1);
        est_HR2_rS1  = est_HR2s_rS1(rS1_ind);
        est_FAR2_rS1 = est_FAR2s_rS1(rS1_ind);
        est_HR2_rS2  = est_HR2s_rS2(rS2_ind);
        est_FAR2_rS2 = est_FAR2s_rS2(rS2_ind);
    end

end


%% package output
fit.meta_d1  = meta_d;
fit.meta_c1  = meta_c;
fit.s        = s;
fit.t2c1_rS1 = t2c_rS1;
fit.t2c1_rS2 = t2c_rS2;

fit.SSE = SSEmin;

fit.est_HR2_rS1  = est_HR2_rS1;
fit.obs_HR2_rS1  = obs_HR2_rS1;

fit.est_FAR2_rS1 = est_FAR2_rS1;
fit.obs_FAR2_rS1 = obs_FAR2_rS1;

fit.est_HR2_rS2  = est_HR2_rS2;
fit.obs_HR2_rS2  = obs_HR2_rS2;

fit.est_FAR2_rS2 = est_FAR2_rS2;
fit.obs_FAR2_rS2 = obs_FAR2_rS2;