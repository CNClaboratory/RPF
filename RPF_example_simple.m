% RPF_example_simple
%
% This example script gives a simple analysis setup to give you the basic
% idea of the RPF toolbox workflow. See RPF_example_flexible to explore 
% using more of the toolbox functionality.
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
% struct properly to your needs. See RPF_guide('info') for more details.


%% prepare

clear

% check if all required toolboxes are in the matlab path
RPF_check_toolboxes

% load the example data set
load trialData_example_discrim.mat


%% analysis for P1 = F1(x)

%%%%% MANUAL SETTINGS FOR F1.info %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% for details on how to set up the info struct, see RPF_guide('info')
F1.info.DV                     = 'd''';
F1.info.PF                     = @RPF_scaled_Weibull;
F1.info.padCells               = 1;
F1.info.set_P_max_to_d_pad_max = 1;
F1.info.x_min                  = 0;
F1.info.x_max                  = 1;
F1.info.x_label                = 'coherence';
F1.info.cond_labels            = {'low density', 'med density', 'high density'};

% for info on the constrain struct, see RPF_guide('constrain')
F1.info.constrain.value.gamma = 0;
F1.info.constrain.value.omega = 'P_max';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this line of code is equivalent to the three lines commented out below
F1 = RPF_get_F(F1.info, trialData);

% % update info
% F1.info = RPF_update_info(F1.info, trialData);
% 
% % get data
% F1.data = RPF_get_F_data(F1.info, trialData);
% 
% % fit data
% F1.fit = RPF_fit_F(F1.info, F1.data);


%% analysis for P2 = F2(x)

%%%%% MANUAL SETTINGS FOR F2.info %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

F2.info.DV          = 'p(high rating)';
F2.info.DV_respCond = 'all'; % possible values are 'rS1', 'rS2', or 'all'
F2.info.PF          = @PAL_Weibull;
F2.info.x_min       = 0;
F2.info.x_max       = 1;
F2.info.x_label     = 'coherence';
F2.info.cond_labels = {'low density', 'med density', 'high density'};

F2.info.constrain   = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this line of code is equivalent to the three lines commented out below
F2 = RPF_get_F(F2.info, trialData);

% % update info
% F2.info = RPF_update_info(F2.info, trialData);
% 
% % get data
% F2.data = RPF_get_F_data(F2.info, trialData);
% 
% % fit data
% F2.fit = RPF_fit_F(F2.info, F2.data);


%% RPF analysis and plots

% get RPF struct
P1_LB = []; % lower bound for AUC. if empty, defaults to min possible value in RPF_get_R
P1_UB = []; % upper bound for AUC. if empty, defaults to max possible value in RPF_get_R
R     = RPF_get_R(F1, F2, P1_LB, P1_UB);

% plot RPF analysis
plotSettings.all.set_title_param = 1;
plotSettings.F{1}.set_legend     = 1;
plotSettings.str_sgtitle         = 'RPF\_example\_simple plot';

% plot F1 alone
RPF_plot(R.F1, plotSettings, 'F')

% plot R alone
RPF_plot(R, plotSettings, 'R')

% plot F1, F2, and R together
RPF_plot(R, plotSettings, 'all');