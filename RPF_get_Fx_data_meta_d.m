function data = RPF_get_Fx_data_meta_d(info, trialData, i_cond)
% data = RPF_get_Fx_data_meta_d(info, trialData, i_cond)

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


% get the empirical meta-d' at each value of x
if strcmp(info.DV_respCond, 'all')
    meta_d_fit_fn = @fit_meta_d_MLE;
else
    meta_d_fit_fn = @fit_rs_meta_d_MLE;
end

switch counts.task_type
    case 'detect x'
        for i_x = 1:size(counts.nR_S2,1)
            fit{i_x} = meta_d_fit_fn(counts.nR_S1, counts.nR_S2(i_x,:));
        end     

    case 'discriminate at x'        
        for i_x = 1:size(counts.nR_S2,1)
            fit{i_x} = meta_d_fit_fn(counts.nR_S1(i_x,:), counts.nR_S2(i_x,:));
        end
end

% extract data of primary interest
for i = 1:length(fit)
    switch info.DV_respCond
        case 'all'
            P(i) = fit{i}.meta_da;

            % save variables of interest from meta-d' fit
            md_fit.meta_d(i) = fit{i}.meta_da;
            md_fit.d(i)      = fit{i}.da;

            md_fit.meta_t1c(i) = fit{i}.meta_ca;
            md_fit.c_prime(i)  = md_fit.meta_t1c(i) ./ md_fit.meta_d(i);

            md_fit.meta_t2c_rS1(i,:) = fit{i}.t2ca_rS1;
            md_fit.meta_t2c_rS2(i,:) = fit{i}.t2ca_rS2;

            md_fit.fit{i} = fit{i};

            % save data used for MLE fit
            forMLE.nC_rS1 = SDT.type2.rS1.nC_rS1;
            forMLE.nI_rS1 = SDT.type2.rS1.nI_rS1;
            forMLE.nC_rS2 = SDT.type2.rS2.nC_rS2;
            forMLE.nI_rS2 = SDT.type2.rS2.nI_rS2;


        case 'rS1'
            P(i) = fit{i}.meta_da_rS1;

            % save variables of interest from meta-d' fit
            md_fit.meta_d_rS1(i) = fit{i}.meta_da_rS1;
            md_fit.d(i)          = fit{i}.da;

            md_fit.meta_t1c(i) = fit{i}.t1ca_rS1;
            md_fit.c_prime(i)  = md_fit.meta_t1c(i) ./ md_fit.meta_d_rS1(i);

            md_fit.meta_t2c_rS1(i,:) = fit{i}.t2ca_rS1;

            md_fit.fit{i} = fit{i};

            % save data used for MLE fit
            forMLE.nC_rS1 = SDT.type2.rS1.nC_rS1;
            forMLE.nI_rS1 = SDT.type2.rS1.nI_rS1;


        case 'rS2'
            P(i) = fit{i}.meta_da_rS2;

            % save variables of interest from meta-d' fit
            md_fit.meta_d_rS2(i) = fit{i}.meta_da_rS2;
            md_fit.d(i)          = fit{i}.da;

            md_fit.meta_t1c(i) = fit{i}.t1ca_rS2;
            md_fit.c_prime(i)  = md_fit.meta_t1c(i) ./ md_fit.meta_d_rS2(i);

            md_fit.meta_t2c_rS2(i,:) = fit{i}.t2ca_rS2;

            md_fit.fit{i} = fit{i};

            % save data used for MLE fit
            forMLE.nC_rS2 = SDT.type2.rS2.nC_rS2;
            forMLE.nI_rS2 = SDT.type2.rS2.nI_rS2;
    end

end

%% package output

data.cond_label  = info.cond_labels;
data.DV          = info.DV;
data.DV_respCond = info.DV_respCond;
data.x           = x;
data.xt          = xt;        

data.P         = P;        
data.d_pad_min = padInfo.d_pad_min;
data.d_pad_max = padInfo.d_pad_max;
data.nRatings  = info.nRatings;

data.md_fit    = md_fit;
data.forMLE    = forMLE;
data.counts    = counts;
data.SDT       = SDT;
data.padInfo   = padInfo;
