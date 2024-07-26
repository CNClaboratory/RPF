function DV_thresh = RPF_get_thresh_for_med_split(rating, nRatings, DV_respCond, response)
% DV_thresh = RPF_get_thresh_for_med_split(rating, nRatings, DV_respCond, response)
%
% Determine the threshold DV_thresh that yields the best balance of trial
% counts between low and high ratings.
%
% INPUTS
% ------
% rating - 1 x nTrials vector containing rating data on each trial. data
%    format should follow the format of trialData.rating (see entry in 
%    RPF_guide('trialData'))
%
% nRatings - number of available ratings in the rating scale
%
% OPTIONAL INPUTS
% ---------------
% The following optional inputs provide the option of restricting the
% calculation of DV_thresh to trials where response was "S1" or "S2", rather 
% than using all trials.
%
% DV_respCond - determines which response types should be used for the data 
%    analysis, i.e. whether we should restrict the analysis to "S1" or "S2" 
%    responses, or include all responses (see entry in RPF_guide('info'))
%
% response - 1 x nTrials vector containing response data on each trial.
%    format should follow the format of trialData.rating (see entry in 
%    RPF_guide('trialData'))
%
% OUTPUT
% ------
% DV_thresh - the threshold value that, when used to define trials as "high
%    rating" if rating >= DV_thresh and "low rating" otherwise, yields the
%    closest match between trial counts in the "low" and "high" categories


% filter for valid ratings
f = rating >= 1 & rating <= nRatings;

% filter by response type
if exist('DV_respCond', 'var') && strcmp(DV_respCond, 'rS1')
    f = f & response == 0;
elseif exist('DV_respCond', 'var') && strcmp(DV_respCond, 'rS2')
    f = f & response == 1;
end

rating = rating(f);

% find threshold that best balances trial counts for low and high
countDiff = Inf;
DV_thresh = [];
for i_thresh = 2:nRatings
    
    nLow  = sum(rating < i_thresh);
    nHigh = sum(rating >= i_thresh);
    
    if abs(nLow - nHigh) < countDiff
        countDiff = abs(nLow - nHigh);
        DV_thresh = i_thresh;
    end
end