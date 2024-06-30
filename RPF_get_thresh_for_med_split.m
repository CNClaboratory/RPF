function DV_thresh = RPF_get_thresh_for_med_split(rating, nRatings, DV_respCond, response)

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