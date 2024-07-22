function options = RPF_plot_update_options(F_or_R, options)
% options = RPF_plot_update_options(F_or_R, options)
% 
% Updates the options struct for RPF_plot by setting default values for
% unspecified fields.
%
% INPUTS
% ------
% F_or_R  - the struct for which the plot will be made. can be either an F
%           struct or an R struct
% options - the options struct for RPF_plot containing prespecified
%           settings. can also be unspecified or empty, in which case all 
%           plot options are set to their default values
%
% OUTPUTS
% -------
% options - the options struct with all unspecified fields set to default
%           values and ready for use with RPF_plot
%
%
% TOP-LEVEL STRUCTURE OF THE options STRUCT
% -----------------------------------------
% The structure of the options struct is described below. Any of its fields
% can be defined manually. Any values not prespecified will be set to
% default values in the output options struct. If the input options
% variable is empty, then the output options struct will contain all
% default values.
%
% options has the following top-level fields:
% * F - a 1x2 cell array holding plot option structs for F1 and F2. if the 
%       input F_or_R is an F1 or F2 struct (as specified in F_or_R.F_ind), 
%       then the corresponding entry of options.F will be updated, and the 
%       other will be an empty array. if F_or_R.F_ind is not specified, then
%       F_ind defaults to 1.
% * R - a plot option struct for R.
% * str_sgtitle - a string holding the title to be used for the subplots of
%       F1, F2, and R using the sgtitle function. [default = '']
% * all - an optional struct that, if specified, will have all of its
%       settings automatically copied to options.F and options.R, so that
%       these settings don't have to be manually specified more than once
% 
% The contents of the options struct that need to be specified depend on
% the plot_type input being used with RPF_plot:
% - plot_type = 'F(x)' -> the struct fields for options.F{F_ind} must be
%                         specified
% - plot_type = 'R'    -> the struct fields for options.R must be specified
% - plot_type = 'all'  -> the struct fields for options.F{1}, options.F{2},
%                         and options.R must be specified
%
% FIELDS OF options.F{i}
% ----------------------
% The fields below contain settings for plotting Pi = Fi(x) as specified in
% options.F{i}, where i = F_or_R.F_ind.
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
% markerColor     - color of data markers, as specified in a 3 x nCond matrix where 
%                   columns are RGB values and rows are conditions
%                   [if options.F{i}.lineColor exists, default = options.F{i}.lineColor; 
%                    else, default = hsv(nCond)]
% lineStyle       - line style used to plot data fits. can be specified as either a 
%                   1 x nCond cell array containing line styles for each condition, or 
%                   as a single string that is applied to every condition 
%                   [default = '-' for every condition]
% lineWidth       - width of fit lines. can be specified as either a 1 x nCond array
%                   of values for each condition, or as a single value that is applied
%                   to every condition [default = 0.5 for every condition]
% lineColor       - color of fit lines, as specified in a 3 x nCond matrix where 
%                   columns are RGB values and rows are conditions
%                   [if markerColor field exists, default = markerColor; 
%                    else, default = hsv(nCond)]
% 
% AXIS LABELS, TITLE, LEGEND
% str_x           - string specifying the x-axis label [default = F{i}.info.x_label] 
% str_P           - string specifying the y-axis label [default = F{i}.info.x_label] 
% str_title       - string specifying plot title [default = '', unless set_title_param == 1]
% set_title_param - if 1, then titles for the plot or subplots containing information 
%                   about fitted parameters are automatically generated [default = 0]
% str_legend      - 1 x nCond cell array containing strings specifying lables for each
%                   condition in the legend [default = '', unless set_legend == 1]
% set_legend      - if 1, then str_legend is automatically defined using 
%                   F{i}.info.cond_labels{i_cond} [default = 0]
%
% FIELDS OF options.R
% -------------------
% The fields below contain settings for plotting P2 = R(P1) as specified in
% options.F{i} and options.R. 
%
% Note that where applicable, default settings for options.R are imported 
% from options.F{i} (e.g. for marker and line properties, etc.)
% 
% AXES
% x_min           - the minimum value of x used to evaluate the plotted fits for P1 and P2 
%                   [default = R.info.x_min]
% x_max           - the maximum value of x used to evaluate the plotted fits for P1 and P2 
%                   [default = R.info.x_max]
% P1_min          - the minimum value for P1 on the x-axis [default = options.F{1}.P_min]
%                   note, this only affets the plot if set_P1_lim_min == 1
% P1_max          - the maximum value for P1 on the x-axis [default = options.F{1}.P_max]
%                   note, this only affets the plot if set_P1_lim_max == 1
% set_P1_lim_min  - set lower bound of x-axis on plot to P1_min 
%                   [default = options.F{1}.set_P_lim_min]
% set_P1_lim_max  - set upper bound of x-axis on plot to P1_max 
%                   [default = options.F{1}.set_P_lim_max]
% P2_min          - the minimum value for P2 on the y-axis [default = options.F{2}.P_min]
%                   note, this only affets the plot if set_P2_lim_min == 1
% P2_max          - the maximum value for P2 on the x-axis [default = options.F{2}.P_max]
%                   note, this only affets the plot if set_P2_lim_max == 1
% set_P2_lim_min  - set lower bound of x-axis on plot to P2_min 
%                   [default = options.F{2}.set_P_lim_min]
% set_P2_lim_max  - set upper bound of x-axis on plot to P2_max 
%                   [default = options.F{2}.set_P_lim_max]
% 
% MARKERS AND LINES
% marker          - marker type used to plot data points. can be specified as either 
%                   a 1 x nCond cell array containing marker strings for each condition, 
%                   or as a single string that is applied to every condition
%                   [default = options.F{1}.marker]
% markerSize      - size of data markers. can be specified as either a 1 x nCond array
%                   of values for each condition, or as a single value that is applied
%                   to every condition [default = options.F{1}.markerSize]
% markerColor     - color of data markers, as specified in a 3 x nCond matrix where 
%                   columns are RGB values and rows are conditions
%                   [if options.R.lineColor exists, default = options.R.lineColor; 
%                    else, default = options.F{1}.markerColor]
% lineStyle       - line style used to plot data fits. can be specified as either a 
%                   1 x nCond cell array containing line styles for each condition, or 
%                   as a single string that is applied to every condition 
%                   [default = options.F{1}.lineStyle]
% lineWidth       - width of fit lines. can be specified as either a 1 x nCond array
%                   of values for each condition, or as a single value that is applied
%                   to every condition [default = options.F{1}.lineWidth]
% lineColor       - color of fit lines, as specified in a 3 x nCond matrix where 
%                   columns are RGB values and rows are conditions
%                   [if options.R.markerColor field exists, default = options.R.markerColor;
%                    else, default = options.F{1}.lineColor]
% marker_partial  - marker type used to plot data points that are only defined for one of
%                   F1 or F2. can be specified as either a 1 x nCond cell array containing 
%                   marker strings for each condition, or as a single string that is 
%                   applied to every condition [default = 'x' for every condition]
% markerSize_partial  - size of partial data markers. can be specified as either a 1 x nCond 
%                   array of values for each condition, or as a single value that is applied
%                   to every condition [default = 8 for every condition]
% markerColor_partial - color of partial data markers, as specified in a 3 x nCond matrix 
%                   where columns are RGB values and rows are conditions 
%                   [default = options.R.markerColor]
% 
% SHADED AUC REGION
% shade_overlap   - if 1, shades the region over which AUC is computed in the R struct. 
%                   this region spans [R.info.P1_LB, R.info.P1_UB]. [default = 1]
% shade_color     - color of the shaded region, as specified in a 1 x 3 array of RGB values
%                   [default = [0.929 .694 .125]]
% shade_alpha     - alpha blending value used for shading [default = 0.1]
% 
% AXIS LABELS, TITLE, LEGEND
% str_P1          - string specifying the x-axis label [default = options.F{1}.str_P] 
% str_P2          - string specifying the y-axis label [default = options.F{2}.str_P] 
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
% FIELDS OF options.all
% -----------------------------------
% To simplify manually defining settings in the options struct, settings
% that are applicable to both options.F{i} and options.R can be defined
% once in options.all, rather than separately defining them in options.F{i}
% and options.R. The settings in options.all will then be copied over
% automatically to options.F{i} and options.R. 
%
% The following fields can be set in options.all :
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



%% determine plot type

switch F_or_R.info.PF_type
    case 'F(x)'
        if ~isfield(F_or_R, 'F_ind') || isempty(F_or_R.F_ind)
            F_ind      = 1;
            F_ind_true = [];
        else
            F_ind      = F_or_R.F_ind;
            F_ind_true = F_ind;
        end
        
        isF(1) = F_ind == 1;
        isF(2) = F_ind == 2;

        switch F_ind
            case 1
                F{1} = F_or_R;
                F{2} = [];
            case 2
                F{1} = [];
                F{2} = F_or_R;
        end
        
        isR    = 0;
        R      = [];
        
    case 'R(P1)'
        
        isR  = 1;
        R    = F_or_R;
        
        isF  = [0 0];
        F{1} = R.F1;
        F{2} = R.F2;
        
end


%% initialize

nCond = F_or_R.info.nCond;

if ~isfield(options, 'F')
    options.F{1} = [];
    options.F{2} = [];
elseif length(options.F) == 1
    options.F{2} = [];
end

if ~isfield(options, 'R')
    options.R    = [];
end


%% import settings from options.all

if isfield(options, 'all') && ~isempty(options.all)
    optall_fields = {'x_min', 'x_max', 'marker', 'markerSize', 'markerColor', ...
        'lineStyle', 'lineWidth', 'lineColor', 'str_x', 'set_title_param'};

    for i_field = 1:length(optall_fields)
        field = optall_fields{i_field};

        if eval(['isfield(options.all, ''' field ''') && ~isempty(options.all.' field ')'])

            % set F options
            for i = 1:2
                if isF(i) || isR    
                    eval(['options.F{i}.' field ' = options.all.' field ';']);
                end
            end

            % set R options
            if isR
                eval(['options.R.' field ' = options.all.' field ';']);
            end
        end
    end
end  


%% configure F(i) options

for i = 1:2

    if isR
        F_ind_true = i;
    end
    
    if isF(i) || isR     
                
        %%% AXES 
        
        % x min and max
        if ~isfield(options.F{i}, 'x_min') || isempty(options.F{i}.x_min)
            options.F{i}.x_min = F{i}.info.x_min;
        end

        if ~isfield(options.F{i}, 'x_max') || isempty(options.F{i}.x_max)
            options.F{i}.x_max = F{i}.info.x_max;
        end

        % axis limits for plotting P
        if ~isfield(options.F{i}, 'set_P_lim_min') || isempty(options.F{i}.set_P_lim_min)
            options.F{i}.set_P_lim_min = 0;
        end

        if ~isfield(options.F{i}, 'set_P_lim_max') || isempty(options.F{i}.set_P_lim_max)
            options.F{i}.set_P_lim_max = 0;
        end
        
        if ~isfield(options.F{i}, 'P_min') || isempty(options.F{i}.P_min)
            options.F{i}.P_min = F{i}.info.P_min;
        end

        if ~isfield(options.F{i}, 'P_max') || isempty(options.F{i}.P_max)
            options.F{i}.P_max = F{i}.info.P_max;
        end


        %%% MARKERS AND LINES
        
        % markers
        if ~isfield(options.F{i}, 'marker') || isempty(options.F{i}.marker)        
            options.F{i}.marker = 'o';
        end
        
        if numel(options.F{i}.marker) == 1
            for i_cond = 1:nCond
                marker{i_cond} = options.F{i}.marker;
            end
            options.F{i}.marker = marker;
        end

        
        if ~isfield(options.F{i}, 'markerSize') || isempty(options.F{i}.markerSize)        
            options.F{i}.markerSize = 6;
        end
        
        if numel(options.F{i}.markerSize) == 1
            options.F{i}.markerSize = options.F{i}.markerSize * ones(1, nCond);
        end        
        
        % lines
        if ~isfield(options.F{i}, 'lineStyle') || isempty(options.F{i}.lineStyle)
            options.F{i}.lineStyle = '-';
        end
        
        if numel(options.F{i}.lineStyle) == 1
            for i_cond = 1:nCond
                lineStyle{i_cond} = options.F{i}.lineStyle;
            end
            options.F{i}.lineStyle = lineStyle;
        end        
        
        if ~isfield(options.F{i}, 'lineWidth') || isempty(options.F{i}.lineWidth)
            options.F{i}.lineWidth = 0.5;
        end
        
        if numel(options.F{i}.lineWidth) == 1
            options.F{i}.lineWidth = options.F{i}.lineWidth * ones(1, nCond);
        end            
       
        
        %%% COLORS
            
        % if markerColor is not specified but lineColor is, set markerColor to lineColor
        if (~isfield(options.F{i}, 'markerColor') || isempty(options.F{i}.markerColor)) && ...
           (isfield(options.F{i}, 'lineColor') && ~isempty(options.F{i}.lineColor))
            options.F{i}.markerColor = options.F{i}.lineColor;
        end

        % if lineColor is not specified but markerColor is, set lineColor to markerColor
        if (~isfield(options.F{i}, 'lineColor') || isempty(options.F{i}.lineColor)) && ...
           (isfield(options.F{i}, 'markerColor') && ~isempty(options.F{i}.markerColor))
            options.F{i}.lineColor = options.F{i}.markerColor;
        end        
        
        % if both markerColor and lineColor are unspecified, set hsv default
        if (~isfield(options.F{i}, 'markerColor') || isempty(options.F{i}.markerColor)) && ...
           (~isfield(options.F{i}, 'lineColor') || isempty(options.F{i}.lineColor))
            options.F{i}.markerColor = hsv(nCond);
            options.F{i}.lineColor   = options.F{i}.markerColor;
        end

        
        % TITLE, AXIS LABELS, LEGEND
        
        % title
        if ~isfield(options.F{i}, 'str_title') || isempty(options.F{i}.str_title)
            options.F{i}.str_title = '';
        end

        if ~isfield(options.F{i}, 'set_title_param') || isempty(options.F{i}.set_title_param)
            options.F{i}.set_title_param = 0;
        end
        
        if options.F{i}.set_title_param
            options.F{i}.str_title = get_preset_titles(F{i}, F_ind_true);
        end        
        
        % axis labels
        if ~isfield(options.F{i}, 'str_x') || isempty(options.F{i}.str_x)
            options.F{i}.str_x = F{i}.info.x_label;
        end

        if ~isfield(options.F{i}, 'str_P') || isempty(options.F{i}.str_P)
            options.F{i}.str_P = F{i}.info.P_label;
        end
        
        
        % legend
        if ~isfield(options.F{i}, 'str_legend') || isempty(options.F{i}.str_legend)
            options.F{i}.str_legend = '';
        end

        if isfield(options.F{i}, 'set_legend') && options.F{i}.set_legend == 1
            options.F{i}.str_legend = F{i}.info.cond_labels;
        end        
        
    end
end


%% configure R options

if isR

    %%% AXES
    
    % x min and max
    if ~isfield(options.R, 'x_min') || isempty(options.R.x_min)
        options.R.x_min = R.info.x_min;
    end

    if ~isfield(options.R, 'x_max') || isempty(options.R.x_max)
        options.R.x_max = R.info.x_max;
    end

    % axis limits for plotting P1
    if ~isfield(options.R, 'set_P1_lim_min') || isempty(options.R.set_P1_lim_min)
        options.R.set_P1_lim_min = options.F{1}.set_P_lim_min;
    end

    if ~isfield(options.R, 'set_P1_lim_max') || isempty(options.R.set_P1_lim_max)
        options.R.set_P1_lim_max = options.F{1}.set_P_lim_max;
    end

    if ~isfield(options.R, 'P1_min') || isempty(options.R.P1_min)
        options.R.P1_min = options.F{1}.P_min;
    end

    if ~isfield(options.R, 'P1_max') || isempty(options.R.P1_max)
        options.R.P1_max = options.F{1}.P_max;
    end  
    
    
    % axis limits for plotting P2
    if ~isfield(options.R, 'set_P2_lim_min') || isempty(options.R.set_P2_lim_min)
        options.R.set_P2_lim_min = options.F{2}.set_P_lim_min;
    end

    if ~isfield(options.R, 'set_P2_lim_max') || isempty(options.R.set_P2_lim_max)
        options.R.set_P2_lim_max = options.F{2}.set_P_lim_max;
    end

    if ~isfield(options.R, 'P2_min') || isempty(options.R.P2_min)
        options.R.P2_min = options.F{2}.P_min;
    end

    if ~isfield(options.R, 'P2_max') || isempty(options.R.P2_max)
        options.R.P2_max = options.F{2}.P_max;
    end      
    
    %%% MARKERS AND LINES
    
    % markers
    if isfield(options.R, 'marker') && ~isempty(options.R.marker) 
        if numel(options.R.marker) == 1
            for i_cond = 1:nCond
                marker{i_cond} = options.R.marker;
            end
            options.R.marker = marker;
        end
    else
        options.R.marker = options.F{1}.marker;
    end    
    
    if isfield(options.R, 'markerSize') && ~isempty(options.R.markerSize) 
        if numel(options.R.markerSize) == 1
            options.R.markerSize = options.R.markerSize * ones(1, nCond);
        end
    else
        options.R.markerSize = options.F{1}.markerSize;
    end
    
    % markers for partial data
    if ~isfield(options.R, 'marker_partial') || isempty(options.R.marker_partial)
        options.R.marker_partial = 'x';
    end
    
    if numel(options.R.marker_partial) == 1
        for i_cond = 1:nCond
            marker_partial{i_cond} = options.R.marker_partial;
        end
        options.R.marker_partial = marker_partial;
    end
    
    
    if ~isfield(options.R, 'markerSize_partial') || isempty(options.R.markerSize_partial)
        options.R.markerSize_partial = 8;
    end
    
    if numel(options.R.markerSize_partial) == 1
        options.R.markerSize_partial = options.R.markerSize_partial * ones(1, nCond);
    end
    
    % lines
    if isfield(options.R, 'lineStyle') && ~isempty(options.R.lineStyle) 
        if numel(options.R.lineStyle) == 1
            for i_cond = 1:nCond
                lineStyle{i_cond} = options.R.lineStyle;
            end
            options.R.lineStyle = lineStyle;
        end
    else
        options.R.lineStyle = options.F{1}.lineStyle;
    end        
    
    if isfield(options.R, 'lineWidth') && ~isempty(options.R.lineWidth) 
        if numel(options.R.lineWidth) == 1
            options.R.lineWidth = options.R.lineWidth * ones(1, nCond);
        end
    else
        options.R.lineWidth = options.F{1}.lineWidth;
    end    
   
    
    %%% COLORS

    % if markerColor is not specified but lineColor is, set markerColor to lineColor
    if (~isfield(options.R, 'markerColor') || isempty(options.R.markerColor)) && ...
       (isfield(options.R, 'lineColor') && ~isempty(options.R.lineColor))
        options.R.markerColor = options.R.lineColor;
    end

    % if lineColor is not specified but markerColor is, set lineColor to markerColor
    if (~isfield(options.R, 'lineColor') || isempty(options.R.lineColor)) && ...
       (isfield(options.R, 'markerColor') && ~isempty(options.R.markerColor))
        options.R.lineColor = options.R.markerColor;
    end        

    % if both markerColor and lineColor are unspecified, set hsv default
    if (~isfield(options.R, 'markerColor') || isempty(options.R.markerColor)) && ...
       (~isfield(options.R, 'lineColor') || isempty(options.R.lineColor))
        options.R.markerColor = options.F{1}.markerColor;
        options.R.lineColor   = options.F{1}.lineColor;
    end

    if (~isfield(options.R, 'markerColor_partial') || isempty(options.R.markerColor_partial))
        options.R.markerColor_partial = options.R.markerColor;
    end        

    %%% TITLE, AXIS LABELS, LEGEND
         
    % title
    if ~isfield(options.R, 'str_title')
        options.R.str_title = '';
    end
    
    if ~isfield(options.R, 'set_title_AUC') || isempty(options.R.set_title_AUC)
        options.R.set_title_AUC = 0;
    end   
    
    if ~isfield(options.R, 'set_title_param') || isempty(options.R.set_title_param)
        options.R.set_title_param = 0;
    end 
    
    if options.R.set_title_AUC
        [param_title, AUC_title] = get_preset_titles(R);
        options.R.str_title      = AUC_title;
    end    
    
    if options.R.set_title_param
        options.R.str_title = get_preset_titles(R);
    end
    
    % axis labels
    if ~isfield(options.R, 'str_P1')
        options.R.str_P1 = options.F{1}.str_P;
    end

    if ~isfield(options.R, 'str_P2')
        options.R.str_P2 = options.F{2}.str_P;
    end    
    
    % legend
    if ~isfield(options.R, 'str_legend') || isempty(options.R.str_legend)
        options.R.str_legend = '';
    end
    
    if isfield(options.R, 'set_legend') && options.R.set_legend == 1
        options.R.str_legend = R.info.cond_labels;
    end
    
    
    %%% AUC
    
    % options for shading RPF AUC region
    if ~isfield(options.R, 'shade_overlap') || isempty(options.R.shade_overlap)
        options.R.shade_overlap = 1;
    end

    if ~isfield(options.R, 'shade_color') || isempty(options.R.shade_color)
        options.R.shade_color = [0.929 .694 .125];
    end

    if ~isfield(options.R, 'shade_alpha') || isempty(options.R.shade_alpha)
        options.R.shade_alpha = .1;
    end    
    
    
end

if ~isfield(options, 'str_sgtitle')
    options.str_sgtitle = '';
end

end


%% function for constructing parameter titles

function [str_title_param, str_title_AUC] = get_preset_titles(F_or_R, F_ind_true)

if ~exist('F_ind_true','var') || isempty(F_ind_true)
    str_F_ind = '';
else
    str_F_ind = ['_' num2str(F_ind_true)];
end

isF = strcmp( F_or_R.info.PF_type, 'F(x)' );
isR = strcmp( F_or_R.info.PF_type, 'R(P1)' );

if isF
    
    F = F_or_R;
    
    % param title is N/A for special PFs
    PFs_special = RPF_get_PF_list('PFs_special');    
    
    if strcmp(func2str(F.info.PF), 'RPF_interp_Fx')
        str_title_param = '(interpolated)';
        
    elseif strcmp(func2str(F.info.PF), 'RPF_meanRating_PF')
        str_title_param = '(composite PF)';
        
    elseif any(strcmp( func2str(F.info.PF), PFs_special ))
        str_title_param = '';
    
    % for all other functions, construct the param title
    else
        F_new  = RPF_structArray2fieldMatrix(F);
        paramF = F_new.fit.params;
        
        PFs_scaled = RPF_get_PF_list('PFs_scaled');
        if any(strcmp(func2str(F.info.PF), PFs_scaled))
            str_param4 = '\omega';
        else
            str_param4 = '\lambda';
        end
        
        % set F title
        str_title_param{1} = ['\alpha' str_F_ind   ' = ' regexprep(num2str(paramF(:,1)', 2), '\s+', ', ')];
        str_title_param{2} = ['\beta' str_F_ind    ' = ' regexprep(num2str(paramF(:,2)', 2), '\s+', ', ')];
        str_title_param{3} = ['\gamma' str_F_ind   ' = ' regexprep(num2str(paramF(:,3)', 2), '\s+', ', ')];
        str_title_param{4} = [str_param4 str_F_ind ' = ' regexprep(num2str(paramF(:,4)', 2), '\s+', ', ')];

        str_title_AUC = '';
    end

elseif isR
    
    R = F_or_R;
    
    % param title is N/A for special PFs
    PFs_special = RPF_get_PF_list('PFs_special');

   if any(strcmp( func2str(R.F1.info.PF), PFs_special )) || ...
      any(strcmp( func2str(R.F2.info.PF), PFs_special ))  

        R_new = RPF_structArray2fieldMatrix(R);
        str_title_param{1} = ['over ' R.F1.info.DV ' = [' regexprep(num2str([R.info.P1_LB, R.info.P1_UB], 2), '\s+', ', ') '], '];
        str_title_param{2} = ['AUC = ['                   regexprep(num2str(R_new.fit.AUC', 3), '\s+', ', ') ']'];
        str_title_param{3} = [R.F2.info.DV '_{avg} = ['   regexprep(num2str(R_new.fit.P2_avg', 3), '\s+', ', ') ']'];
    
        str_title_AUC = str_title_param;
        
    % for all other functions, construct the param title
    else
        R_new   = RPF_structArray2fieldMatrix(R);
        paramF1 = R_new.fit.params.F1;
        paramF2 = R_new.fit.params.F2;
        paramR  = paramF2 ./ paramF1;

        % set R title
        str_title_param{1} = ['\alpha_2 / \alpha_1 = '    regexprep(num2str(paramR(:,1)', 2),   '\s+', ', ')];
        str_title_param{2} = ['\beta_2 / \beta_1 = '      regexprep(num2str(paramR(:,2)', 2),   '\s+', ', ')];
        str_title_param{3} = ['over ' R.F1.info.DV ' = [' regexprep(num2str([R.info.P1_LB, R.info.P1_UB], 2), '\s+', ', ') '], '];
        str_title_param{4} = ['AUC = ['                   regexprep(num2str(R_new.fit.AUC', 3), '\s+', ', ') ']'];
        str_title_param{5} = [R.F2.info.DV '_{avg} = ['   regexprep(num2str(R_new.fit.P2_avg', 3), '\s+', ', ') ']'];

        str_title_AUC{1} = str_title_param{3};
        str_title_AUC{2} = str_title_param{4};
        str_title_AUC{3} = str_title_param{5};
        
    end
    
end

end