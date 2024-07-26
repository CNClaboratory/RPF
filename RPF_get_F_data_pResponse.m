function data = RPF_get_F_data_pResponse(info, trialData, i_cond)
% data = RPF_get_F_data_pResponse(info, trialData, i_cond)

%% filter by condition

if exist('i_cond','var') && ~isempty(i_cond)
    trialData = RPF_filter_trialData(trialData, info.nRatings, info.cond_vals(i_cond));

    info.cond_vals   = info.cond_vals(i_cond);
    info.cond_labels = info.cond_labels{i_cond};
end


%% get data

[nPos, nTot] = RPF_trials2counts_binary(trialData.x, trialData.response == 1, info.x_vals);

%% package output

data.cond_label = info.cond_labels;
data.DV         = info.DV;
data.x          = info.x_vals;
data.xt         = info.xt_vals;

data.P = nPos ./ nTot;

data.forMLE.nPos = nPos;
data.forMLE.nTot = nTot;