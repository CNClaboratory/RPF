function data = RPF_get_F_data_d(info, trialData, i_cond)
% data = RPF_get_F_data_d(info, trialData, i_cond)

%% filter by condition

if exist('i_cond','var') && ~isempty(i_cond)
    trialData = RPF_filter_trialData(trialData, info.nRatings, info.cond_vals(i_cond));

    info.cond_vals   = info.cond_vals(i_cond);
    info.cond_labels = info.cond_labels{i_cond};
end

%% get data

% filter out any trials where accuracy is undefined due to stimID
% being undefined, e.g. as in a discrimination task where x=0
if any(trialData.stimID == 0.5)
    exclude_undef_stimID = 1;
    trialData = RPF_filter_trialData(trialData, info.nRatings, info.cond_vals, [], exclude_undef_stimID);
end

[counts, padInfo] = RPF_trials2counts_SDT(trialData, info);
SDT               = RPF_SDT_analysis(counts);

% for detection tasks, d' is computed by comparing responses at all
% x > 0 to responses at x == 0, so d' is undefined at x == 0
if strcmp(counts.task_type, 'detect x')
    x  = info.x_vals(2:end);
    xt = info.xt_vals(2:end);
else
    x  = info.x_vals;
    xt = info.xt_vals;
end


%% package output

data.cond_label  = info.cond_labels;
data.DV          = info.DV;
data.x           = x;
data.xt          = xt;        

data.P         = SDT.type1.d;        
data.d_pad_min = padInfo.d_pad_min;
data.d_pad_max = padInfo.d_pad_max;
data.nRatings  = info.nRatings;

data.forMLE.nH  = SDT.type1.nH;
data.forMLE.nF  = SDT.type1.nF;
data.forMLE.nM  = SDT.type1.nM;
data.forMLE.nCR = SDT.type1.nCR;

data.counts   = counts;
data.SDT      = SDT;
data.padInfo  = padInfo;

end