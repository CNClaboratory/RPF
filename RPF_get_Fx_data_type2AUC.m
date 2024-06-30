function data = RPF_get_Fx_data_type2AUC(info, trialData, i_cond)
% data = RPF_get_Fx_data_type2AUC(info, trialData, i_cond)

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
% x > 0 to responses at x == 0, so d' (and meta-d') is undefined at x == 0
if strcmp(counts.task_type, 'detect x')
    x  = info.x_vals(2:end);
    xt = info.xt_vals(2:end);
else
    x  = info.x_vals;
    xt = info.xt_vals;
end        


switch counts.task_type
    case 'detect x'
        % in detection there is only one S1 stimulus; remaining conditions are S2 stimuli
        for i_x = 1:size(counts.nR_S2,1)
            AUC{i_x} = RPF_type2AUC_analysis(counts.nR_S1, counts.nR_S2(i_x,:), info.DV_respCond);
        end

    case 'discriminate at x'         
        for i_x = 1:size(counts.nR_S2,1)
            AUC{i_x} = RPF_type2AUC_analysis(counts.nR_S1(i_x,:), counts.nR_S2(i_x,:), info.DV_respCond);
        end         
end

for i = 1:length(AUC)
    P(i)            = AUC{i}.obs_Ag;
    t2AUC.Ag_obs(i) = AUC{i}.obs_Ag;
    t2AUC.Ag_exp(i) = AUC{i}.exp_Ag;
end


%% package output

data.cond_label  = info.cond_labels;
data.DV          = info.DV;
data.DV_respCond = info.DV_respCond;
data.x           = x;
data.xt          = xt;        

data.P = P;
data.nRatings = info.nRatings;

data.t2AUC    = t2AUC;
data.counts   = counts;
data.SDT      = SDT;
data.padInfo  = padInfo;
