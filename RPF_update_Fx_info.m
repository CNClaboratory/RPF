function info = RPF_update_Fx_info(info, trialData)
% info = RPF_update_Fx_info(info, trialData)
% 
% Update the info struct with default values for unspecified fields. 
% 
% See RPF_guide('info') and RPF_guide('trialData') for more information on
% these structs.

%% check info.DV

if ~isfield(info, 'DV') || isempty(info.DV)
    error('RPF:invalidOption', ['\ninfo.DV must be specified.\n\n' ...
                                'See "help RPF_info" for how to configure the info struct.'])
end

if ~any(strcmp(info.DV, RPF_get_DV_list('DVs_all')))
    error('RPF:invalidOption', ['\ninfo.DV is set to ''' info.DV ''', but this is not a recognized DV type.\n' ... 
                                'See "help RPF_get_DV_list" for lists of available DVs.\n\n' ...
                                'See "help RPF_info" for how to configure the info struct.'])
end


%% PF type

if ~isfield(info, 'PF_type') || isempty(info.PF_type)
    info.PF_type = 'F(x)';
end


%% fit type

% set default fit type
if ~isfield(info, 'fit_type') || isempty(info.fit_type)
    
    if isfield(info, 'PF') && strcmp(func2str(info.PF), 'RPF_interp_Fx')
        info.fit_type = 'interp';
    elseif any(strcmp(info.DV, {'type 2 AUC', 'RT'}))
        info.fit_type = 'SSE';
    else
        info.fit_type = 'MLE';
    end
    
end

% check that fit_type is compatible with PF for interpolation
if (strcmp(info.fit_type, 'interp') && ~strcmp(func2str(info.PF), 'RPF_interp_Fx')) || ...
   (~strcmp(info.fit_type, 'interp') && strcmp(func2str(info.PF), 'RPF_interp_Fx'))

    error('RPF:invalidOption', ['\nThe following settings in the info struct are incompatible:\n' ...
                                '- info.fit_type is set to ''' info.fit_type '''\n' ... 
                                '- info.PF is set to @' func2str(info.PF) '\n\n' ...
                                'The ''interp'' fit type can only be used with the @RPF_interp_Fx PF, and vice versa.\n\n' ...
                                'See "help RPF_info" for how to configure the info struct.'])
end

% check that fit_type is compatible with PF for mean rating
if (strcmp(info.fit_type, 'SSE') && strcmp(func2str(info.PF), 'RPF_meanRating_PF'))
    
    error('RPF:invalidOption', ['\nThe following settings in the info struct are incompatible:\n' ...
                                '- info.fit_type is set to ''' info.fit_type '''\n' ... 
                                '- info.PF is set to @' func2str(info.PF) '\n\n' ...
                                'The @RPF_meanRating_PF function can only be used with the the fit_type of MLE.\n\n' ...
                                'See "help RPF_info" for how to configure the info struct.'])
end

% check that MLE fit_type is compatible with DV
if strcmp(info.fit_type, 'MLE') && any(strcmp(info.DV, {'type 2 AUC', 'RT'}))

    error('RPF:invalidOption', ['\nThe following settings in the info struct are incompatible:\n' ...
                                '- info.fit_type is set to ''' info.fit_type '''\n' ... 
                                '- info.DV is set to ''' info.DV '''\n\n' ...
                                'MLE fitting is not currently available for ''' info.DV '''. Use SSE or interpolation instead.\n\n' ...
                                'See "help RPF_info" for how to configure the info struct.'])
end

% warn if SSE fit_type is requested for a probability DV
if strcmp(info.fit_type, 'SSE') && any(strcmp(info.DV, {'p(correct)', 'p(high rating)', 'p(response)'}))

    warning('RPF:invalidOption', ['\nThe following settings in the info struct are not ideal:\n' ...
                                '- info.fit_type is set to ''' info.fit_type '''\n' ... 
                                '- info.DV is set to ''' info.DV '''\n\n' ...
                                'SSE fitting is not ideal for ''' info.DV '''. Consider using MLE instead.\n\n' ...
                                'See "help RPF_info" for how to configure the info struct.'])
end

% set default for interp_method
if strcmp(info.fit_type, 'interp') && (~isfield(info, 'interp_method') || isempty(info.interp_method))
    info.interp_method = 'linear';
end


%% PF

% set default PF
if ~isfield(info, 'PF') || isempty(info.PF)
    
    if strcmp(info.fit_type, 'interp')
        info.PF = @RPF_interp_Fx;
        
    else
        switch info.DV
            case {'p(response)', 'p(correct)', 'p(high rating)'}
                info.PF = @PAL_Weibull;

            case {'d''', 'meta-d''', 'type 2 AUC', 'RT'}
                info.PF = @RPF_scaled_Weibull;

            case 'mean rating'
                if strcmp(info.fit_type, 'MLE')
                    info.PF = @RPF_meanRating_PF;
                    if ~isfield(info, 'PF_pHighRating') || isempty(info.PF_pHighRating)
                        info.PF_pHighRating = @PAL_Weibull;
                    end
                else
                    info.PF = @RPF_scaled_Weibull;
                end
        end
    end    
end


%% x transform

if ~isfield(info, 'xt_fn') || isempty(info.xt_fn)
    if strcmp(info.DV, 'mean rating')
        PF_for_xt = info.PF_pHighRating;
    else
        PF_for_xt = info.PF;
    end
    [info.xt_fn, info.xt_fn_inv] = RPF_get_PF_xt_fn(PF_for_xt);
end


%% x vals, min, max

[x_vals_all, x_vals_with_defined_stimID] = RPF_get_x_info(trialData);

% since info.x_vals is a list of x values where info.DV is defined
% (corresponding to the list of performance values in data.P), it must not
% include any x values where info.DV is undefined
if any(strcmp(info.DV, {'p(correct)', 'd''', 'meta-d''', 'type 2 AUC'}))
    x_vals_valid = x_vals_with_defined_stimID;
else
    x_vals_valid = x_vals_all;
end

% since x_min and x_max determine lower and upper x value bounds on AUC
% calculation, they are not restricted to defined stimID ranges like x_vals
% is
x_vals_all_min = min(x_vals_all);
x_vals_all_max = max(x_vals_all);


% set default values for x_vals, x_min and x_max
if ~isfield(info, 'x_vals') || isempty(info.x_vals)
    info.x_vals  = x_vals_valid;
end

if ~isfield(info, 'x_min') || isempty(info.x_min)
    info.x_min  = x_vals_all_min;
end

if ~isfield(info, 'x_max') || isempty(info.x_max)
    info.x_max  = x_vals_all_max;
end


%% x info for interpolation

% if interpolating, enforce consistent x_min and x_max values
if strcmp(func2str(info.PF), 'RPF_interp_Fx')
    
    % default append_xP_min
    if ~isfield(info, 'append_xP_min') || isempty(info.append_xP_min)
        info.append_xP_min = 0;
    end
    
    % default append_xP_max
    if ~isfield(info, 'append_xP_max') || isempty(info.append_xP_max)
        info.append_xP_max = 0;
    end
       
    % if info.x_min is not an appended data point, ensure it's not smaller than
    % the minimum x value in the data, since this would require
    % extrapolation beyond the available data and this cannot be achieved
    % via interpolation
    if ~info.append_xP_min && info.x_min < x_vals_all_min
        warnText = ['resetting info.x_min from ' num2str(info.x_min) ' to minimum x value in the trial data of ' num2str(x_vals_all_min) ' for consistency with interpolation method']; 
        warning('RPF:invalidOption', warnText);
        info.x_min = x_vals_all_min;
    end

    % if x_max is not an appended data point, ensure it's not larger than
    % the maximum x value in the data, since this would require
    % extrapolation beyond the available data and this cannot be achieved
    % via interpolation
    if ~info.append_xP_max && info.x_max > x_vals_all_max
        warnText = ['resetting info.x_max from ' num2str(info.x_max) ' to maximum x value in the trial data of ' num2str(x_vals_all_max) ' for consistency with interpolation method']; 
        warning('RPF:invalidOption', warnText);
        info.x_max = x_vals_all_max;
    end
    
    % if x_min is supposed to be an appended data point but it's not smaller
    % than the minimum x value in the data, reset info.append_xP_min = 0
    if info.append_xP_min && info.x_min >= min(x_vals_valid) % x_min_calc
        warnText = ['the input value of info.append_xP_min is 1, but ' ...
                    'the input value of info.x_min = ' num2str(info.x_min) ' is not smaller than the min x value in the data of ' num2str(x_vals_all_min) ', ' ...
                    'so info.append_xP_min will be automatically reset to 0.']; 
        warning('RPF:invalidOption', warnText);
        info.append_xP_min = 0;
    end

    % if x_max is supposed to be an appended data point but it's not larger
    % than the maximum x value in the data, reset info.append_xP_max = 0
    if info.append_xP_max && info.x_max <= x_vals_all_max
        warnText = ['the input value of info.append_xP_max is 1, but ' ...
                    'the input value of info.x_max = ' num2str(info.x_max) ' is not larger than the max x value in the data of ' num2str(x_vals_all_max) ', ' ...
                    'so info.append_xP_max will be automatically reset to 0.']; 
        warning('RPF:invalidOption', warnText);
        info.append_xP_max = 0;
    end    
    
end


%% xt info

if ~isfield(info, 'xt_vals') || isempty(info.xt_vals)
    info.xt_vals = info.xt_fn(info.x_vals);
end

if ~isfield(info, 'xt_min') || isempty(info.xt_min)
    info.xt_min = info.xt_fn(info.x_min);
end

if ~isfield(info, 'xt_max') || isempty(info.xt_max)
    info.xt_max = info.xt_fn(info.x_max);
end


%% cond vals

% cond_vals
if ~isfield(info, 'cond_vals') || isempty(info.cond_vals)
    if ~isfield(trialData, 'condition')
        info.cond_vals = 0;
    else
        f = ~isinf(trialData.condition) & ~isnan(trialData.condition);
        info.cond_vals = unique(trialData.condition(f));
    end
end

% nCond
if ~isfield(info, 'nCond') || isempty(info.nCond)
    info.nCond = length(info.cond_vals);
end


%% nRatings

if ~isfield(info, 'nRatings') || isempty(info.nRatings)
    if ~isfield(trialData, 'rating')
        info.nRatings = 1;
    else
        f = ~isinf(trialData.rating) & ~isnan(trialData.rating);
        info.nRatings = max(trialData.rating(f));
    end
end


%% thresh for p(response)

% if strcmp(info.DV, 'p(response)')
%     if ~isfield(info, 'DV_thresh') || isempty(info.DV_thresh)
%         info.DV_thresh = nRatings + 1;
%     end
% end


%% response condition for applicable variables

if any( strcmp(info.DV, {'p(correct)', 'p(high rating)', 'mean rating', 'type 2 AUC', 'meta-d''', 'RT'}) )
    
    % DV_respCond
    if ~isfield(info, 'DV_respCond') || isempty(info.DV_respCond)
        info.DV_respCond = 'all';
    end
    
end


%% threshold for p(high rating)

if strcmp(info.DV, 'p(high rating)')
    
    % if DV_thresh is undefined, set to median split
    if ~isfield(info, 'DV_thresh') || isempty(info.DV_thresh)
        info.DV_thresh_type = 'median split';
    else
        info.DV_thresh_type = 'pre-specified';
    end    

    % if DV_thresh_type is defined as median split, set DV_thresh accordingly
    if isfield(info, 'DV_thresh_type') && strcmp(info.DV_thresh_type, 'median split')
        info.DV_thresh = RPF_get_thresh_for_med_split(trialData.rating, info.nRatings, info.DV_respCond, trialData.response);
    end
    
end


%% pad info for d', meta-d', and type 2 AUC

if any(strcmp(info.DV, {'d''', 'meta-d''', 'type 2 AUC'}))

    if ~isfield(info, 'useAllPaddingSettings') || isempty(info.useAllPaddingSettings)
        info.useAllPaddingSettings = 0;
    end
    
    if info.useAllPaddingSettings
        info.padCells                       = 1;
        info.padCells_correctForTrialCounts = 1;
        info.padCells_nonzero_d             = 1;
        info.set_P_min_to_d_pad_min         = 1;
        info.set_P_max_to_d_pad_max         = 1;
    end
    
    if ~isfield(info, 'padCells') || isempty(info.padCells)
        info.padCells = 0;
    end

    if info.padCells == 0
        info.padAmount = 0;
    elseif ~isfield(info, 'padAmount') || isempty(info.padAmount)
        info.padAmount = 1 / (2*info.nRatings);
    end
    
    if ~isfield(info, 'padCells_correctForTrialCounts') || isempty(info.padCells_correctForTrialCounts)
        info.padCells_correctForTrialCounts = 0;
    end    
    
    if ~isfield(info, 'padCells_nonzero_d') || isempty(info.padCells_nonzero_d)
        info.padCells_nonzero_d = 0;
    end

    if info.padCells_nonzero_d == 0
        info.padAmount_nonzero_d = 0;
    elseif ~isfield(info, 'padAmount_nonzero_d') || isempty(info.padAmount_nonzero_d)
        info.padAmount_nonzero_d = 1e-4;
    end
    
    
    % get full padInfo
    for i_cond = 1:length(info.cond_vals)

        trialData_i = RPF_filter_trialData(trialData, info.nRatings, info.cond_vals(i_cond));

        info_i      = info;
        info_i.cond_vals   = info_i.cond_vals(i_cond);
        info_i.cond_labels = info_i.cond_labels{i_cond};
        
        [counts, padInfo(i_cond)] = RPF_trials2counts_SDT(trialData_i, info_i);
    end 
    
    info.padInfo = padInfo;
    
    info.d_pad_min = min( [info.padInfo.d_pad_min] );
    info.d_pad_max = max( [info.padInfo.d_pad_max] );
    
    
end


%% P1 min and max

if isfield(info, 'padCells') && info.padCells == 1
    if ~isfield(info, 'set_P_min_to_d_pad_min') || isempty(info.set_P_min_to_d_pad_min)
        info.set_P_min_to_d_pad_min = 0;
    end

    if ~isfield(info, 'set_P_max_to_d_pad_max') || isempty(info.set_P_max_to_d_pad_max)
        info.set_P_max_to_d_pad_max = 0;
    end
end

switch info.DV
    case {'p(correct)', 'type 2 AUC'}
        P_min = 0.5;
        P_max = 1;
        
    case {'p(response)', 'p(high rating)'}
        P_min = 0;
        P_max = 1;

    case 'mean rating'
        P_min = 1;
        P_max = info.nRatings;
        
    case {'d''', 'meta-d'''}
        
        if isfield(info, 'set_P_min_to_d_pad_min') && info.set_P_min_to_d_pad_min
            P_min = info.padInfo.d_pad_min;
        else
            P_min = 0;
        end
        
        if isfield(info, 'set_P_max_to_d_pad_max') && info.set_P_max_to_d_pad_max
            P_max = info.padInfo.d_pad_max;
        else
            P_max = 5;
        end
        
    case 'RT'
        P_min = 0;
        P_max = max(trialData.RT);

end

if ~isfield(info, 'P_min') || isempty(info.P_min)
    info.P_min  = P_min;
end

if ~isfield(info, 'P_max') || isempty(info.P_max)
    info.P_max  = P_max;
end

%% x label

if ~isfield(info, 'x_label') || isempty(info.x_label)
    info.x_label = 'x';
end


%% P label

if ~isfield(info, 'P_label') || isempty(info.P_label)
   
    str_respCond = '';
    if any( strcmp(info.DV, {'p(high rating)', 'mean rating', 'type 2 AUC', 'meta-d'''}) )
        if strcmp(info.DV_respCond, 'rS1')
            str_respCond = ' for resp="S1"';
        elseif strcmp(info.DV_respCond, 'rS2')
            str_respCond = ' for resp="S2"';
        end
    end
            
    info.P_label = [info.DV str_respCond];
        
end


%% cond labels

if ~isfield(info, 'cond_labels') || isempty(info.cond_labels)
    for i_cond = 1:length(info.cond_vals)
        info.cond_labels{i_cond} = ['cond = ' num2str(info.cond_vals(i_cond))];
    end
end