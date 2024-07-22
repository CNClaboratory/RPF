% RPF_example_flexible
%
% This example script is more complicated than RPF_example_simple, but
% gives you a chance to quickly play with all the options for analyzing an
% example data set.
%
% In the example data set analyzed here, x represents dot motion coherence, 
% ranging from 0 to 1, and there are three experimental conditions for low,
% medium, and high dot density. The task on each trial was to discern if a
% patch of coherently moving dots occurred on the left or right side of the
% screen, and rate confidence on a scale of 1 to 4.
%
% Note that the bulk of the analysis workflow consists in setting up your
% info structs properly. If you want to try adjusting this example to your
% own purposes, make sure you pay special attention to adapting the info
% struct properly to your needs. See "help RPF_info" for more detail.


%% prepare

clear

% check if all required toolboxes are in the matlab path
RPF_check_toolboxes

% load the example data set
load trialData_example_discrim.mat


%% Manual settings for F1 and F2
% in this section you can quickly change the main variables that need to be
% set manually

%%%%% F1 settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

F1_DV = 1;          % select DV for F1
                    % 1 = p(correct), 2 = d', 3 = p(response)

F1_fit = 1;         % select fit type for F1
                    % 1 = MLE, 2 = SSE, 3 = interp

F1_extrapolate = 1; % options for setting the x-range over which F1 is evaluated
                    % 0 = confine x-range to values used in expt (x_min=0.1, x_max=0.8)
                    % 1 = extrapolate to the widest x-range possible (x_min=0, x_max=1)

F1_use_log_PF = 1;  % option for selecting PF based on type of x-axis values
                    % 0 = select a PF that uses untransformed x values
                    % 1 = select a PF that uses log-transformed x values                

                    
%%%%% F2 settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

F2_DV = 1;          % select DV for F2
                    % 1 = p(high rating), 2 = mean rating, 3 = meta-d', 4 = type 2 AUC, 5 = RT

F2_DV_respCond = 3; % select DV response condition for F2
                    % 1 = "S1" responses, 2 = "S2" responses, 3 = all responses

F2_fit = 1;         % select fit type for F2
                    % 1 = MLE, 2 = SSE, 3 = interp

F2_extrapolate = 1; % options for setting the x-range over which F2 is evaluated  
                    % 0 = confine x-range to values used in expt (x_min=0.1, x_max=0.8)
                    % 1 = extrapolate to the widest x-range possible (x_min=0, x_max=1)

F2_use_log_PF = 1;  % option for selecting PF based on type of x-axis values
                    % 0 = select a PF that uses untransformed x values
                    % 1 = select a PF that uses log-transformed x values                    
                    
                    
%%

type1_DVs    = {'p(correct)', 'd''', 'p(response)'};
type2_DVs    = {'p(high rating)', 'mean rating', 'meta-d''', 'type 2 AUC', 'RT'}; 
DV_respConds = {'rS1', 'rS2', 'all'};
fit_types    = {'MLE', 'SSE', 'interp'};


F1.info.DV = type1_DVs{F1_DV};
F1.info.fit_type = fit_types{F1_fit};

F2.info.DV = type2_DVs{F2_DV};
F2.info.DV_respCond = DV_respConds{F2_DV_respCond};
F2.info.fit_type = fit_types{F2_fit};


%% F1 - define info and data
% in this section, further automated setup is conducted based on the manual
% settings above, but the details of the automated setup can also be
% changed if desired

constrain1 = [];

switch F1.info.DV
    case 'd'''
        F1.info.padCells = 1;
        F1.info.padCells_nonzero_d = 1;

        if F1_use_log_PF
            F1.info.PF = @RPF_scaled_Gumbel;
        else
            F1.info.PF = @RPF_scaled_Weibull;
        end
        
        constrain1.value.gamma = 0;
        
    otherwise % below applies to both p(correct) and p(response)
        if strcmp(F1.info.DV, 'p(correct)')
            constrain1.value.gamma = 0.5;
        end
        
        if F1_use_log_PF
            F1.info.PF = @PAL_Gumbel;
        else
            F1.info.PF = @PAL_Weibull;
        end
end

if strcmp(F1.info.fit_type, 'interp')
    F1.info.PF            = @RPF_interp_Fx;
    F1.info.append_xP_min = 0;
    F1.info.append_xP_max = 0;
    F1.info.interp_method = 'linear';
end

if F1_extrapolate
    F1.info.x_min  = 0;
    F1.info.x_max  = 1;
end

F1.info.x_label     = 'coherence';
F1.info.cond_labels = {'low density', 'med density', 'high density'};


% update info
F1.info = RPF_update_Fx_info(F1.info, trialData);

% get data
F1.data = RPF_get_Fx_data(F1.info, trialData);

if isfield(F1.data(1), 'padInfo') && isfield(F1.data(1).padInfo, 'd_pad_max')
    F1.info.P_max          = max( [F1.data.d_pad_max] );
    constrain1.value.omega = max( [F1.data.d_pad_max] );
end

% fit
F1.fit = RPF_fit_Fx(F1.info, F1.data, constrain1);


%% F2 - define info and data
% in this section, further automated setup is conducted based on the manual
% settings above, but the details of the automated setup can also be
% changed if desired

constrain2 = [];

switch F2.info.DV
    case 'mean rating'
        
        if strcmp(F2.info.fit_type, 'MLE')
            F2.info.PF = @RPF_meanRating_PF;
        elseif strcmp(F2.info.fit_type, 'SSE')
            if F2_use_log_PF
                F2.info.PF = @RPF_scaled_Gumbel;
            else
                F2.info.PF = @RPF_scaled_Weibull;
            end
        end
            
        if F2_use_log_PF
            F2.info.PF_pHighRating = @PAL_Gumbel;
        else
            F2.info.PF_pHighRating = @PAL_Weibull;
        end
        
    case {'meta-d''', 'type 2 AUC'}
        F2.info.padCells = 1;
        F2.info.padCells_nonzero_d = 1;
        if F2_use_log_PF
            F2.info.PF = @RPF_scaled_Gumbel;
        else        
            F2.info.PF = @RPF_scaled_Weibull;
        end

    case 'RT'
        if F2_use_log_PF
            F2.info.PF = @RPF_scaled_Gumbel;
        else        
            F2.info.PF = @RPF_scaled_Weibull;
        end        
        
    otherwise
        if F2_use_log_PF
            F2.info.PF = @PAL_Gumbel;
        else
            F2.info.PF = @PAL_Weibull;
        end
end

if strcmp(F2.info.fit_type, 'interp')
    F2.info.PF            = @RPF_interp_Fx;
    F2.info.append_xP_min = 0;
    F2.info.append_xP_max = 0;
end

if F2_extrapolate
    F2.info.x_min  = 0;
    F2.info.x_max  = 1;
end

F2.info.x_label     = 'coherence';
F2.info.cond_labels = {'low density', 'med density', 'high density'};

% update info
F2.info = RPF_update_Fx_info(F2.info, trialData);

% get data
F2.data = RPF_get_Fx_data(F2.info, trialData);


if strcmp(F2.info.DV, 'meta-d''')
    
    constrain2.value.gamma = 0;
    
    if isfield(F2.data(1), 'd_pad_max')
        F2.info.P_max          = max( [F2.data.d_pad_max] );
        constrain2.value.omega = max( [F2.data.d_pad_max] );
    end
    
elseif strcmp(F2.info.DV, 'type 2 AUC')
    constrain2.value.gamma = 0.5;
    constrain2.value.omega = 1;
end

% fit
F2.fit = RPF_fit_Fx(F2.info, F2.data, constrain2);



%% RPF analysis and plots

% get RPF struct
P1_LB = []; % lower bound for AUC. if empty, defaults to min possible value in RPF_get_R
P1_UB = []; % upper bound for AUC. if empty, defaults to max possible value in RPF_get_R
R     = RPF_get_R(F1, F2, P1_LB, P1_UB);


% plot RPF analysis
options.all.set_title_param = 1;
options.F{1}.default_legend = 1;
options.str_sgtitle         = 'RPF\_example\_flexible plot';

options.all.lineColor = cool(F1.info.nCond);

RPF_plot(R, options, 'all');