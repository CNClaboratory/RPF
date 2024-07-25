% RPF_guide_plotSettings
%
% Description of the plotSettings struct used in the RPF toolbox. 
% 
% plotSettings is a struct whose fields contain settings for formatting the
% appearance of plots made with RPF_plot. Its top-level fields are structs
% corresponding to settings for F1, F2, and R plots, respectively, each of
% which contains fields controlling specific aspects of the plot
% appearance.
% 
% Most fields have sensible default values, such that you only need to 
% specify a handful of fields that are unique to your use case, and allow 
% the rest to take on their default values. The only field with no default 
% value that must be defined manually is info.DV.
%
% After manually defining your fields of interest, you can use plotSettings 
% as an input to the RPF_plot function, where any unspecified fields will be 
% automatically set to their default values using the function 
% RPF_update_plotSettings. Alternatively, if you use RPF_plot without passing 
% in plotSettings as an input, all default plot settings will be used.
% 
% TOP-LEVEL STRUCTURE OF THE plotSettings STRUCT
% ----------------------------------------------
% plotSettings has the following top-level fields:
% 
% F 
%   - a 1x2 cell array holding structs for plot settings for F1 and F2. if 
%     using RPF_plot for an F1 or F2 struct (where the F index is specified 
%     in F.F_ind), specify your plot settings in plotSettings.F{F.F_ind}. 
%     if F.F_ind is not specified, specify your plot settings in
%     plotsSettings.F{1}.
%
% R
%   - a struct for plot settings for R.
% 
% str_sgtitle 
%   - a string holding the main overarching title to be used for the subplots 
%     of F1, F2, and R using the sgtitle function. 
%   * DEFAULT = ''
%
% all 
%  - an optional struct that, if specified, will have all of its settings 
%    automatically copied to plotSettings.F{1}, plotSettings.F{2}, and 
%    plotSettings.R, so that these settings don't have to be manually 
%    specified separately for each
% 
% The contents of the plotSettings struct that need to be specified depend on
% the PF_type input being used with RPF_plot:
% - PF_type = 'F(x)' -> the struct fields for plotSettings.F{F.F_ind} (if 
%                         F.F_ind is defined) or plotSettings.F{1} (if F.F_ind 
%                         is undefined) must be specified
% - PF_type = 'R'    -> the struct fields for plotSettings.R must be specified
% - PF_type = 'all'  -> the struct fields for plotSettings.F{1}, plotSettings.F{2},
%                         and plotSettings.R must be specified
%
% FIELDS OF plotSettings.F{i}
% ---------------------------
% The fields below contain settings for plotting Pi = Fi(x) as specified in
% plotSettings.F{i}, where i = F.F_ind.
%
% AXES
% x_min           - the minimum value to plot on the x-axis [default = F{i}.info.x_min]
% x_max           - the maximum value to plot on the x-axis [default = F{i}.info.x_max]
% P_min           - the minimum value for P [default = F{i}.info.P_min]
%                   note, this only affets the plot if set_P_lim_min == 1
% P_max           - the maximum value for P [default = F{i}.info.P_max]
%                   note, this only affets the plot if set_P_lim_max == 1
% set_P_lim_min   - set lower bound of y-axis on plot to P_min [default = 0]
% set_P_lim_max   - set upper bound of y-axis on plot to P_max [default = 0]
%
% MARKERS AND LINES
% marker          - marker type used to plot data points. can be specified as either 
%                   a 1 x nCond cell array containing marker strings for each condition, 
%                   or as a single string that is applied to every condition
%                   [default = 'o' for every condition]
% markerSize      - size of data markers. can be specified as either a 1 x nCond array
%                   of values for each condition, or as a single value that is applied
%                   to every condition [default = 6 for every condition]
% markerColor     - color of data markers, as specified in an nCond x 3 matrix where 
%                   rows are conditions and columns are RGB values
%                   [if plotSettings.F{i}.lineColor exists, default = plotSettings.F{i}.lineColor; 
%                    else, default = hsv(nCond)]
% lineStyle       - line style used to plot data fits. can be specified as either a 
%                   1 x nCond cell array containing line styles for each condition, or 
%                   as a single string that is applied to every condition 
%                   [default = '-' for every condition]
% lineWidth       - width of fit lines. can be specified as either a 1 x nCond array
%                   of values for each condition, or as a single value that is applied
%                   to every condition [default = 0.5 for every condition]
% lineColor       - color of fit lines, as specified in an nCond x 3 matrix where 
%                   rows are conditions and columns are RGB values
%                   [if markerColor field exists, default = markerColor; 
%                    else, default = hsv(nCond)]
% 
% AXIS LABELS, TITLE, LEGEND
% str_x           - string specifying the x-axis label [default = Fi.info.x_label] 
% str_P           - string specifying the y-axis label [default = Fi.info.x_label] 
% str_title       - string specifying plot title [default = '', unless set_title_param == 1]
% set_title_param - if 1, then titles for the plot or subplots containing information 
%                   about fitted parameters are automatically generated [default = 0]
% str_legend      - 1 x nCond cell array containing strings specifying lables for each
%                   condition in the legend [default = '', unless set_legend == 1]
% set_legend      - if 1, then str_legend is automatically defined using 
%                   Fi.info.cond_labels{i_cond} [default = 0]
%
% FIELDS OF plotSettings.R
% -------------------
% The fields below contain settings for plotting P2 = R(P1) as specified in
% plotSettings.F{i} and plotSettings.R. 
%
% Note that where applicable, default settings for plotSettings.R are imported 
% from plotSettings.F{i} (e.g. for marker and line properties, axis settings, etc.)
% 
% AXES
% x_min           - the minimum value of x used to evaluate the plotted fits for P1 and P2 
%                   [default = R.info.x_min]
% x_max           - the maximum value of x used to evaluate the plotted fits for P1 and P2 
%                   [default = R.info.x_max]
% P1_min          - the minimum value for P1 on the x-axis [default = plotSettings.F{1}.P_min]
%                   note, this only affets the plot if set_P1_lim_min == 1
% P1_max          - the maximum value for P1 on the x-axis [default = plotSettings.F{1}.P_max]
%                   note, this only affets the plot if set_P1_lim_max == 1
% set_P1_lim_min  - set lower bound of x-axis on plot to P1_min 
%                   [default = plotSettings.F{1}.set_P_lim_min]
% set_P1_lim_max  - set upper bound of x-axis on plot to P1_max 
%                   [default = plotSettings.F{1}.set_P_lim_max]
% P2_min          - the minimum value for P2 on the y-axis [default = plotSettings.F{2}.P_min]
%                   note, this only affets the plot if set_P2_lim_min == 1
% P2_max          - the maximum value for P2 on the x-axis [default = plotSettings.F{2}.P_max]
%                   note, this only affets the plot if set_P2_lim_max == 1
% set_P2_lim_min  - set lower bound of x-axis on plot to P2_min 
%                   [default = plotSettings.F{2}.set_P_lim_min]
% set_P2_lim_max  - set upper bound of x-axis on plot to P2_max 
%                   [default = plotSettings.F{2}.set_P_lim_max]
% 
% MARKERS AND LINES
% marker          - marker type used to plot data points. can be specified as either 
%                   a 1 x nCond cell array containing marker strings for each condition, 
%                   or as a single string that is applied to every condition
%                   [default = plotSettings.F{1}.marker]
% markerSize      - size of data markers. can be specified as either a 1 x nCond array
%                   of values for each condition, or as a single value that is applied
%                   to every condition [default = plotSettings.F{1}.markerSize]
% markerColor     - color of data markers, as specified in a 3 x nCond matrix where 
%                   columns are RGB values and rows are conditions
%                   [if plotSettings.R.lineColor exists, default = plotSettings.R.lineColor; 
%                    else, default = plotSettings.F{1}.markerColor]
% lineStyle       - line style used to plot data fits. can be specified as either a 
%                   1 x nCond cell array containing line styles for each condition, or 
%                   as a single string that is applied to every condition 
%                   [default = plotSettings.F{1}.lineStyle]
% lineWidth       - width of fit lines. can be specified as either a 1 x nCond array
%                   of values for each condition, or as a single value that is applied
%                   to every condition [default = plotSettings.F{1}.lineWidth]
% lineColor       - color of fit lines, as specified in a 3 x nCond matrix where 
%                   columns are RGB values and rows are conditions
%                   [if plotSettings.R.markerColor field exists, default = plotSettings.R.markerColor;
%                    else, default = plotSettings.F{1}.lineColor]
% marker_partial  - marker type used to plot data points that are only defined for one of
%                   F1 or F2. can be specified as either a 1 x nCond cell array containing 
%                   marker strings for each condition, or as a single string that is 
%                   applied to every condition [default = 'x' for every condition]
% markerSize_partial  - size of partial data markers. can be specified as either a 1 x nCond 
%                   array of values for each condition, or as a single value that is applied
%                   to every condition [default = 8 for every condition]
% markerColor_partial - color of partial data markers, as specified in a 3 x nCond matrix 
%                   where columns are RGB values and rows are conditions 
%                   [default = plotSettings.R.markerColor]
% 
% SHADED AUC REGION
% shade_overlap   - if 1, shades the region over which AUC is computed in the R struct. 
%                   this region spans [R.info.P1_LB, R.info.P1_UB]. [default = 1]
% shade_color     - color of the shaded region, as specified in a 1 x 3 array of RGB values
%                   [default = [0.929 .694 .125]]
% shade_alpha     - alpha blending value used for shading [default = 0.1]
% 
% AXIS LABELS, TITLE, LEGEND
% str_P1          - string specifying the x-axis label [default = plotSettings.F{1}.str_P] 
% str_P2          - string specifying the y-axis label [default = plotSettings.F{2}.str_P] 
% str_title       - string specifying plot title [default = '', unless set_title_param == 1]
% set_title_AUC   - if 1, and if set_title_param ~= 1, then a title containing information 
%                   about AUC values is automatically generated [default = 0]
% set_title_param - if 1, then a title containing information about fitted parameters and 
%                   AUC values is automatically generated [default = 0]
% str_legend      - 1 x nCond cell array containing strings specifying lables for each
%                   condition in the legend [default = '', unless set_legend == 1]
% set_legend      - if 1, then str_legend is automatically defined using R.info.cond_labels 
%                   [default = 0]
%
% FIELDS OF plotSettings.all
% -----------------------------------
% To simplify manually defining settings in the plotSettings struct, settings
% that are applicable to all of plotSettings.F{1}, plotSettings.F{2}, and 
% plotSettings.R can be defined once in plotSettings.all, rather than separately 
% defining them in plotSettings.F{i} and plotSettings.R. The settings in 
% plotSettings.all will then be copied over automatically to plotSettings.F{i} 
% and plotSettings.R when used by RPF_plot.
%
% The following fields can be set in plotSettings.all :
%
% x_min
% x_max
% marker
% markerSize
% markerColor
% lineStyle
% lineWidth
% lineColor
% str_x
% set_title_param