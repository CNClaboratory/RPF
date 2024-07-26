function plotSettings = RPF_update_plotSettings(F_or_R, plotSettings)
% plotSettings = RPF_update_plotSettings(F_or_R, plotSettings)
% 
% Updates the plotSettings struct for RPF_plot by setting default values for
% unspecified fields.
%
% INPUTS
% ------
% F_or_R       - the struct for which the plot will be made. can be either an F
%                struct or an R struct
% plotSettings - the plotSettings struct for RPF_plot containing prespecified
%                settings. can also be unspecified or empty, in which case all 
%                plot settings are set to their default values. see
%                RPF_guide('plotSettings') for more information
%
% OUTPUTS
% -------
% plotSettings - the plotSettings struct with all unspecified fields set to 
%                default values and ready for use with RPF_plot


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

if ~isfield(plotSettings, 'F')
    plotSettings.F{1} = [];
    plotSettings.F{2} = [];
elseif length(plotSettings.F) == 1
    plotSettings.F{2} = [];
end

if ~isfield(plotSettings, 'R')
    plotSettings.R    = [];
end


%% import settings from plotSettings.all

if isfield(plotSettings, 'all') && ~isempty(plotSettings.all)
    optall_fields = {'x_min', 'x_max', 'marker', 'markerSize', 'markerColor', ...
        'lineStyle', 'lineWidth', 'lineColor', 'str_x', 'set_title_param'};

    for i_field = 1:length(optall_fields)
        field = optall_fields{i_field};

        if eval(['isfield(plotSettings.all, ''' field ''') && ~isempty(plotSettings.all.' field ')'])

            % set F plotSettings
            for i = 1:2
                if isF(i) || isR    
                    eval(['plotSettings.F{i}.' field ' = plotSettings.all.' field ';']);
                end
            end

            % set R plotSettings
            if isR
                eval(['plotSettings.R.' field ' = plotSettings.all.' field ';']);
            end
        end
    end
end  


%% configure F(i) plotSettings

for i = 1:2

    if isR
        F_ind_true = i;
    end
    
    if isF(i) || isR     
                
        %%% AXES 
        
        % x min and max
        if ~isfield(plotSettings.F{i}, 'x_min') || isempty(plotSettings.F{i}.x_min)
            plotSettings.F{i}.x_min = F{i}.info.x_min;
        end

        if ~isfield(plotSettings.F{i}, 'x_max') || isempty(plotSettings.F{i}.x_max)
            plotSettings.F{i}.x_max = F{i}.info.x_max;
        end

        % axis limits for plotting P
        if ~isfield(plotSettings.F{i}, 'set_P_lim_min') || isempty(plotSettings.F{i}.set_P_lim_min)
            plotSettings.F{i}.set_P_lim_min = 0;
        end

        if ~isfield(plotSettings.F{i}, 'set_P_lim_max') || isempty(plotSettings.F{i}.set_P_lim_max)
            plotSettings.F{i}.set_P_lim_max = 0;
        end
        
        if ~isfield(plotSettings.F{i}, 'P_min') || isempty(plotSettings.F{i}.P_min)
            plotSettings.F{i}.P_min = F{i}.info.P_min;
        end

        if ~isfield(plotSettings.F{i}, 'P_max') || isempty(plotSettings.F{i}.P_max)
            plotSettings.F{i}.P_max = F{i}.info.P_max;
        end


        %%% MARKERS AND LINES
        
        % markers
        if ~isfield(plotSettings.F{i}, 'marker') || isempty(plotSettings.F{i}.marker)        
            plotSettings.F{i}.marker = 'o';
        end
        
        if numel(plotSettings.F{i}.marker) == 1
            for i_cond = 1:nCond
                marker{i_cond} = plotSettings.F{i}.marker;
            end
            plotSettings.F{i}.marker = marker;
        end

        
        if ~isfield(plotSettings.F{i}, 'markerSize') || isempty(plotSettings.F{i}.markerSize)        
            plotSettings.F{i}.markerSize = 6;
        end
        
        if numel(plotSettings.F{i}.markerSize) == 1
            plotSettings.F{i}.markerSize = plotSettings.F{i}.markerSize * ones(1, nCond);
        end        
        
        % lines
        if ~isfield(plotSettings.F{i}, 'lineStyle') || isempty(plotSettings.F{i}.lineStyle)
            plotSettings.F{i}.lineStyle = '-';
        end
        
        if numel(plotSettings.F{i}.lineStyle) == 1
            for i_cond = 1:nCond
                lineStyle{i_cond} = plotSettings.F{i}.lineStyle;
            end
            plotSettings.F{i}.lineStyle = lineStyle;
        end        
        
        if ~isfield(plotSettings.F{i}, 'lineWidth') || isempty(plotSettings.F{i}.lineWidth)
            plotSettings.F{i}.lineWidth = 0.5;
        end
        
        if numel(plotSettings.F{i}.lineWidth) == 1
            plotSettings.F{i}.lineWidth = plotSettings.F{i}.lineWidth * ones(1, nCond);
        end            
       
        
        %%% COLORS
            
        % if markerColor is not specified but lineColor is, set markerColor to lineColor
        if (~isfield(plotSettings.F{i}, 'markerColor') || isempty(plotSettings.F{i}.markerColor)) && ...
           (isfield(plotSettings.F{i}, 'lineColor') && ~isempty(plotSettings.F{i}.lineColor))
            plotSettings.F{i}.markerColor = plotSettings.F{i}.lineColor;
        end

        % if lineColor is not specified but markerColor is, set lineColor to markerColor
        if (~isfield(plotSettings.F{i}, 'lineColor') || isempty(plotSettings.F{i}.lineColor)) && ...
           (isfield(plotSettings.F{i}, 'markerColor') && ~isempty(plotSettings.F{i}.markerColor))
            plotSettings.F{i}.lineColor = plotSettings.F{i}.markerColor;
        end        
        
        % if both markerColor and lineColor are unspecified, set hsv default
        if (~isfield(plotSettings.F{i}, 'markerColor') || isempty(plotSettings.F{i}.markerColor)) && ...
           (~isfield(plotSettings.F{i}, 'lineColor') || isempty(plotSettings.F{i}.lineColor))
            plotSettings.F{i}.markerColor = hsv(nCond);
            plotSettings.F{i}.lineColor   = plotSettings.F{i}.markerColor;
        end

        
        % TITLE, AXIS LABELS, LEGEND
        
        % title
        if ~isfield(plotSettings.F{i}, 'str_title') || isempty(plotSettings.F{i}.str_title)
            plotSettings.F{i}.str_title = '';
        end

        if ~isfield(plotSettings.F{i}, 'set_title_param') || isempty(plotSettings.F{i}.set_title_param)
            plotSettings.F{i}.set_title_param = 0;
        end
        
        if plotSettings.F{i}.set_title_param
            plotSettings.F{i}.str_title = get_preset_titles(F{i}, F_ind_true);
        end        
        
        % axis labels
        if ~isfield(plotSettings.F{i}, 'str_x') || isempty(plotSettings.F{i}.str_x)
            plotSettings.F{i}.str_x = F{i}.info.x_label;
        end

        if ~isfield(plotSettings.F{i}, 'str_P') || isempty(plotSettings.F{i}.str_P)
            plotSettings.F{i}.str_P = F{i}.info.P_label;
        end
        
        
        % legend
        if ~isfield(plotSettings.F{i}, 'str_legend') || isempty(plotSettings.F{i}.str_legend)
            plotSettings.F{i}.str_legend = '';
        end

        if isfield(plotSettings.F{i}, 'set_legend') && plotSettings.F{i}.set_legend == 1
            plotSettings.F{i}.str_legend = F{i}.info.cond_labels;
        end        
        
    end
end


%% configure R plotSettings

if isR

    %%% AXES
    
    % x min and max
    if ~isfield(plotSettings.R, 'x_min') || isempty(plotSettings.R.x_min)
        plotSettings.R.x_min = R.info.x_min;
    end

    if ~isfield(plotSettings.R, 'x_max') || isempty(plotSettings.R.x_max)
        plotSettings.R.x_max = R.info.x_max;
    end

    % axis limits for plotting P1
    if ~isfield(plotSettings.R, 'set_P1_lim_min') || isempty(plotSettings.R.set_P1_lim_min)
        plotSettings.R.set_P1_lim_min = plotSettings.F{1}.set_P_lim_min;
    end

    if ~isfield(plotSettings.R, 'set_P1_lim_max') || isempty(plotSettings.R.set_P1_lim_max)
        plotSettings.R.set_P1_lim_max = plotSettings.F{1}.set_P_lim_max;
    end

    if ~isfield(plotSettings.R, 'P1_min') || isempty(plotSettings.R.P1_min)
        plotSettings.R.P1_min = plotSettings.F{1}.P_min;
    end

    if ~isfield(plotSettings.R, 'P1_max') || isempty(plotSettings.R.P1_max)
        plotSettings.R.P1_max = plotSettings.F{1}.P_max;
    end  
    
    
    % axis limits for plotting P2
    if ~isfield(plotSettings.R, 'set_P2_lim_min') || isempty(plotSettings.R.set_P2_lim_min)
        plotSettings.R.set_P2_lim_min = plotSettings.F{2}.set_P_lim_min;
    end

    if ~isfield(plotSettings.R, 'set_P2_lim_max') || isempty(plotSettings.R.set_P2_lim_max)
        plotSettings.R.set_P2_lim_max = plotSettings.F{2}.set_P_lim_max;
    end

    if ~isfield(plotSettings.R, 'P2_min') || isempty(plotSettings.R.P2_min)
        plotSettings.R.P2_min = plotSettings.F{2}.P_min;
    end

    if ~isfield(plotSettings.R, 'P2_max') || isempty(plotSettings.R.P2_max)
        plotSettings.R.P2_max = plotSettings.F{2}.P_max;
    end      
    
    %%% MARKERS AND LINES
    
    % markers
    if isfield(plotSettings.R, 'marker') && ~isempty(plotSettings.R.marker) 
        if numel(plotSettings.R.marker) == 1
            for i_cond = 1:nCond
                marker{i_cond} = plotSettings.R.marker;
            end
            plotSettings.R.marker = marker;
        end
    else
        plotSettings.R.marker = plotSettings.F{1}.marker;
    end    
    
    if isfield(plotSettings.R, 'markerSize') && ~isempty(plotSettings.R.markerSize) 
        if numel(plotSettings.R.markerSize) == 1
            plotSettings.R.markerSize = plotSettings.R.markerSize * ones(1, nCond);
        end
    else
        plotSettings.R.markerSize = plotSettings.F{1}.markerSize;
    end
    
    % markers for partial data
    if ~isfield(plotSettings.R, 'marker_partial') || isempty(plotSettings.R.marker_partial)
        plotSettings.R.marker_partial = 'x';
    end
    
    if numel(plotSettings.R.marker_partial) == 1
        for i_cond = 1:nCond
            marker_partial{i_cond} = plotSettings.R.marker_partial;
        end
        plotSettings.R.marker_partial = marker_partial;
    end
    
    
    if ~isfield(plotSettings.R, 'markerSize_partial') || isempty(plotSettings.R.markerSize_partial)
        plotSettings.R.markerSize_partial = 8;
    end
    
    if numel(plotSettings.R.markerSize_partial) == 1
        plotSettings.R.markerSize_partial = plotSettings.R.markerSize_partial * ones(1, nCond);
    end
    
    % lines
    if isfield(plotSettings.R, 'lineStyle') && ~isempty(plotSettings.R.lineStyle) 
        if numel(plotSettings.R.lineStyle) == 1
            for i_cond = 1:nCond
                lineStyle{i_cond} = plotSettings.R.lineStyle;
            end
            plotSettings.R.lineStyle = lineStyle;
        end
    else
        plotSettings.R.lineStyle = plotSettings.F{1}.lineStyle;
    end        
    
    if isfield(plotSettings.R, 'lineWidth') && ~isempty(plotSettings.R.lineWidth) 
        if numel(plotSettings.R.lineWidth) == 1
            plotSettings.R.lineWidth = plotSettings.R.lineWidth * ones(1, nCond);
        end
    else
        plotSettings.R.lineWidth = plotSettings.F{1}.lineWidth;
    end    
   
    
    %%% COLORS

    % if markerColor is not specified but lineColor is, set markerColor to lineColor
    if (~isfield(plotSettings.R, 'markerColor') || isempty(plotSettings.R.markerColor)) && ...
       (isfield(plotSettings.R, 'lineColor') && ~isempty(plotSettings.R.lineColor))
        plotSettings.R.markerColor = plotSettings.R.lineColor;
    end

    % if lineColor is not specified but markerColor is, set lineColor to markerColor
    if (~isfield(plotSettings.R, 'lineColor') || isempty(plotSettings.R.lineColor)) && ...
       (isfield(plotSettings.R, 'markerColor') && ~isempty(plotSettings.R.markerColor))
        plotSettings.R.lineColor = plotSettings.R.markerColor;
    end        

    % if both markerColor and lineColor are unspecified, set hsv default
    if (~isfield(plotSettings.R, 'markerColor') || isempty(plotSettings.R.markerColor)) && ...
       (~isfield(plotSettings.R, 'lineColor') || isempty(plotSettings.R.lineColor))
        plotSettings.R.markerColor = plotSettings.F{1}.markerColor;
        plotSettings.R.lineColor   = plotSettings.F{1}.lineColor;
    end

    if (~isfield(plotSettings.R, 'markerColor_partial') || isempty(plotSettings.R.markerColor_partial))
        plotSettings.R.markerColor_partial = plotSettings.R.markerColor;
    end        

    %%% TITLE, AXIS LABELS, LEGEND
         
    % title
    if ~isfield(plotSettings.R, 'str_title')
        plotSettings.R.str_title = '';
    end
    
    if ~isfield(plotSettings.R, 'set_title_AUC') || isempty(plotSettings.R.set_title_AUC)
        plotSettings.R.set_title_AUC = 0;
    end   
    
    if ~isfield(plotSettings.R, 'set_title_param') || isempty(plotSettings.R.set_title_param)
        plotSettings.R.set_title_param = 0;
    end 
    
    if plotSettings.R.set_title_AUC
        [param_title, AUC_title] = get_preset_titles(R);
        plotSettings.R.str_title      = AUC_title;
    end    
    
    if plotSettings.R.set_title_param
        plotSettings.R.str_title = get_preset_titles(R);
    end
    
    % axis labels
    if ~isfield(plotSettings.R, 'str_P1')
        plotSettings.R.str_P1 = plotSettings.F{1}.str_P;
    end

    if ~isfield(plotSettings.R, 'str_P2')
        plotSettings.R.str_P2 = plotSettings.F{2}.str_P;
    end    
    
    % legend
    if ~isfield(plotSettings.R, 'str_legend') || isempty(plotSettings.R.str_legend)
        plotSettings.R.str_legend = '';
    end
    
    if isfield(plotSettings.R, 'set_legend') && plotSettings.R.set_legend == 1
        plotSettings.R.str_legend = R.info.cond_labels;
    end
    
    
    %%% AUC
    
    % plotSettings for shading RPF AUC region
    if ~isfield(plotSettings.R, 'shade_overlap') || isempty(plotSettings.R.shade_overlap)
        plotSettings.R.shade_overlap = 1;
    end

    if ~isfield(plotSettings.R, 'shade_color') || isempty(plotSettings.R.shade_color)
        plotSettings.R.shade_color = [0.929 .694 .125];
    end

    if ~isfield(plotSettings.R, 'shade_alpha') || isempty(plotSettings.R.shade_alpha)
        plotSettings.R.shade_alpha = .1;
    end    
    
    
end

if ~isfield(plotSettings, 'str_sgtitle')
    plotSettings.str_sgtitle = '';
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
    
    if strcmp(func2str(F.info.PF), 'RPF_interp_PF')
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