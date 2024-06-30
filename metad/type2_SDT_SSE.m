function out = type2_SDT_SSE(nR_S1, nR_S2)

% out = type2_SDT(nR_S1, nR_S2)
%
% Given data from an experiment where an observer discriminates between two
% stimulus alternatives on every trial and provides confidence ratings,
% provides a type 2 SDT analysis of the data.
%
% The function does a standard type 1 SDT analysis on the raw behavioral
% data and then does a type 2 SDT analysis using the function fit_meta_d 
% with d_min = -5, d_grain = .01, d_max = 5
% 
% INPUTS
%    
% nR_S1, nR_S2
% 
% nR_S1 and nR_S2 are vectors containing the total number of responses in
% each response category, conditional on presentation of S1 and S2.
% size of each array is 2*nRatings, where each element corresponds to a
% count of responses in each response category. Response categories are
% ordered as follows:
% highest conf "S1" ... lowest conf "S1", lowest conf "S2", ... highest conf "S2"
%
% e.g. if nR_S1 = [100 50 20 10 5 1], then when stimulus S1 was
% presented, the subject had the following response counts:
% responded S1, rating=3 : 100 times
% responded S1, rating=2 : 50 times
% responded S1, rating=1 : 20 times
% responded S2, rating=1 : 10 times
% responded S2, rating=2 : 5 times
% responded S2, rating=3 : 1 time
%
% The ordering of response / rating counts for S2 should be the same as it
% is for S1. e.g. if nR_S2 = [3 7 8 12 27 89], then when stimulus S2 was
% presented, the subject had the following response counts:
% responded S1, rating=3 : 3 times
% responded S1, rating=2 : 7 times
% responded S1, rating=1 : 8 times
% responded S2, rating=1 : 12 times
% responded S2, rating=2 : 27 times
% responded S2, rating=3 : 89 times
%
%
% OUTPUTS
%
% out.d_a       : d_a for input data. If s=1, d_a = d'
% out.meta_d_a  : meta_d_a for input data
% out.M_ratio   : meta_d_a / d_a; measure of metacognitive efficiency
% out.M_diff    : meta_d_a - d_a; measure of metacognitive efficiency
% out.s         : ratio of evidence distribution standard deviations assumed for the analysis. 
% out.type2_fit : output of fit_meta_d_SSE for the type 2 SDT fit.

% 10/14/14 - removed support for unequal variance SDT model
%          - removed support for input data format describing
%            trial-by-trial outcomes (function "trials2counts" is now
%            provided on http://www.columbia.edu/~bsm2105/type2sdt/ to
%            convert trial data to response count data)
% 9/7/10 - bm - wrote it

%% parse inputs

% check for valid inputs
if ~( length(nR_S1) == length(nR_S2) && mod(length(nR_S2),2) == 0 )
    error('nR_S1 and nR_S2 must be the same length and have an even number of elements')
end

nRatings = length(nR_S1) / 2;


%% standard SDT analysis

HR1  = sum(nR_S2(nRatings+1:end)) / sum(nR_S2);
FAR1 = sum(nR_S1(nRatings+1:end)) / sum(nR_S1);

for i=2:2*nRatings
    ratingHRs(i-1)  = sum(nR_S2(i:end)) / sum(nR_S2);
    ratingFARs(i-1) = sum(nR_S1(i:end)) / sum(nR_S1);
end

% if equalVariance
%     s = 1;
% else
%     p = polyfit(norminv(ratingFARs), norminv(ratingHRs), 1);
%     s = p(1);    
% end

s = 1;

% d' and c in terms of S1 distribution standard deviation units
d_1 = (1/s)*norminv(HR1) - norminv(FAR1);
c_1 = (-1/(1+s)) * (norminv(HR1)+norminv(FAR1));
cprime = c_1 / d_1;


%% type 2 SDT analysis

% get type 2 HR and FAR for S1 responses
for i = 1 : nRatings-1
    HR2_rS1(i)  = sum(nR_S1(1:i)) / sum(nR_S1(1:nRatings));
    FAR2_rS1(i) = sum(nR_S2(1:i)) / sum(nR_S2(1:nRatings));
end

% get type 2 HR and FAR for S2 responses
for i = nRatings+2 : 2*nRatings
    HR2_rS2(i - (nRatings+2) + 1)  = sum(nR_S2(i:end)) / sum(nR_S2(nRatings+1:end));
    FAR2_rS2(i - (nRatings+2) + 1) = sum(nR_S1(i:end)) / sum(nR_S1(nRatings+1:end));
end

d_min = -5;
d_grain = .01;
d_max = 5;

fit = fit_meta_d_SSE(HR2_rS1, FAR2_rS1, HR2_rS2, FAR2_rS2, cprime, s, d_min, d_max, d_grain);

%% package output
out.da        = d_1 * s * sqrt(2/(1+s^2));
out.meta_da   = fit.meta_d1 * s * sqrt(2/(1+s^2));
out.M_ratio   = out.meta_da / out.da;
out.M_diff    = out.meta_da - out.da;
out.s         = s;
out.type2_fit = fit;