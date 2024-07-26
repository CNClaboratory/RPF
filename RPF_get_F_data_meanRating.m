function data = RPF_get_F_data_meanRating(info, trialData, i_cond)
% data = RPF_get_F_data_meanRating(info, trialData, i_cond)

%% filter by condition

if exist('i_cond','var') && ~isempty(i_cond)
    trialData = RPF_filter_trialData(trialData, info.nRatings, info.cond_vals(i_cond));

    info.cond_vals   = info.cond_vals(i_cond);
    info.cond_labels = info.cond_labels{i_cond};
end


%% get data

% filter by response condition
if isfield(info, 'DV_respCond') && any(strcmp(info.DV_respCond, {'rS1', 'rS2'}))
    trialData = RPF_filter_trialData(trialData, info.nRatings, info.cond_vals, info.DV_respCond);
end

% compute mean rating at each x
f_rating = trialData.rating >= 1 & trialData.rating <= info.nRatings;
for i_x = 1:length(info.x_vals)
    f_x    = trialData.x == info.x_vals(i_x);
    f      = f_x & f_rating;
    P(i_x) = mean(trialData.rating(f));
end

% get data for fitting each p(rating >= i) where i = [2, nRatings] since
% these are used in the MLE fit for mean rating
for i_rating = 2:info.nRatings
    [nPos, nTot] = RPF_trials2counts_binary(trialData.x, trialData.rating >= i_rating, info.x_vals);

    pHighRating(i_rating-1).P           = nPos ./ nTot;
    pHighRating(i_rating-1).forMLE.nPos = nPos;
    pHighRating(i_rating-1).forMLE.nTot = nTot;
end


%% package output

data.cond_label  = info.cond_labels;
data.DV          = info.DV;
data.DV_respCond = info.DV_respCond;
data.x           = info.x_vals;
data.xt          = info.xt_vals;        

data.P = P;

data.pHighRating = pHighRating;