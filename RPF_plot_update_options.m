function options = RPF_plot_update_options(F_or_R, options)
% options = RPF_plot_update_options(F_or_R, options)


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

            % set R optoins
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


        % line and marker styles
        if ~isfield(options.F{i}, 'marker') || isempty(options.F{i}.marker)
            for i_cond = 1:nCond
                options.F{i}.marker{i_cond} = 'o';
            end
        end

        if ~isfield(options.F{i}, 'markerSize') || isempty(options.F{i}.markerSize)
            for i_cond = 1:nCond
                options.F{i}.markerSize{i_cond} = 6;
            end
        end        
        
        if ~isfield(options.F{i}, 'lineStyle') || isempty(options.F{i}.lineStyle)
            for i_cond = 1:nCond
                options.F{i}.lineStyle{i_cond} = '-';
            end
        end

        if ~isfield(options.F{i}, 'lineWidth') || isempty(options.F{i}.lineWidth)
            for i_cond = 1:nCond
                options.F{i}.lineWidth{i_cond} = 0.5;
            end
        end        
        
       
        % colors
            
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

        
        % titles and axis labels
        if ~isfield(options.F{i}, 'str_x') || isempty(options.F{i}.str_x)
            options.F{i}.str_x = F{i}.info.x_label;
        end

        if ~isfield(options.F{i}, 'str_P') || isempty(options.F{i}.str_P)
            options.F{i}.str_P = F{i}.info.P_label;
        end

        if ~isfield(options.F{i}, 'str_legend') || isempty(options.F{i}.str_legend)
            options.F{i}.str_legend = '';
        end

        if isfield(options.F{i}, 'default_legend') && options.F{i}.default_legend == 1
            for i_cond = 1:nCond
                options.F{i}.str_legend{i_cond} = F{i}.info.cond_labels{i_cond};
            end
        end        
        
        if ~isfield(options.F{i}, 'set_title_param') || isempty(options.F{i}.set_title_param)
            options.F{i}.set_title_param = 0;
        end
        
        if ~isfield(options.F{i}, 'str_title') || isempty(options.F{i}.str_title)
            options.F{i}.str_title = '';
        end
        
        if isempty(options.F{i}.str_title) && options.F{i}.set_title_param
            options.F{i}.str_title = get_preset_titles(F{i}, F_ind_true);
        end
        
    end
end


%% configure R options

if isR

    % x min and max
    if ~isfield(options.R, 'x_min') || isempty(options.R.x_min)
        options.R.x_min = R.info.x_min;
    end

    if ~isfield(options.R, 'x_max') || isempty(options.R.x_max)
        options.R.x_max = R.info.x_max;
    end


    % line and marker styles
    if ~isfield(options.R, 'marker') || isempty(options.R.marker)
        for i_cond = 1:nCond
            options.R.marker{i_cond} = options.F{1}.marker{i_cond};
        end
    end
    
    if ~isfield(options.R, 'markerSize') || isempty(options.R.markerSize)
        for i_cond = 1:nCond
            options.R.markerSize{i_cond} = options.F{1}.markerSize{i_cond};
        end
    end    

    if ~isfield(options.R, 'marker_partial') || isempty(options.R.marker_partial)
        for i_cond = 1:nCond
            options.R.marker_partial{i_cond} = 'x';
        end
    end
    
    if ~isfield(options.R, 'markerSize_partial') || isempty(options.R.markerSize_partial)
        for i_cond = 1:nCond
            options.R.markerSize_partial{i_cond} = 8;
        end
    end

    if ~isfield(options.R, 'lineStyle') || isempty(options.R.lineStyle)
        for i_cond = 1:nCond
            options.R.lineStyle{i_cond} = options.F{1}.lineStyle{i_cond};
        end
    end

    if ~isfield(options.R, 'lineWidth') || isempty(options.R.lineWidth)
        for i_cond = 1:nCond
            options.R.lineWidth{i_cond} = options.F{1}.lineWidth{i_cond};
        end
    end
    
    % colors

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

    
    % titles and axis labels
    if ~isfield(options.R, 'str_legend') || isempty(options.R.str_legend)
        options.R.str_legend = '';
    end
    
    if isfield(options.R, 'default_legend') && options.R.default_legend == 1
        for i_cond = 1:nCond
            options.R.str_legend{i_cond} = R.info.cond_labels{i_cond};
        end
    end   
        
    if ~isfield(options.R, 'str_title')
        options.R.str_title = '';
    end
    
    if ~isfield(options.R, 'set_title_param') || isempty(options.R.set_title_param)
        options.R.set_title_param = 0;
    end
    
    if ~isfield(options.R, 'set_title_AUC') || isempty(options.R.set_title_AUC)
        options.R.set_title_AUC = 0;
    end    
    
    if isempty(options.R.str_title) && options.R.set_title_param
        options.R.str_title = get_preset_titles(R);
    end
    
    if isempty(options.R.str_title) && options.R.set_title_AUC
        [param_title, AUC_title] = get_preset_titles(R);
        options.R.str_title      = AUC_title;
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
        str_title_param{1} = ['AUC = ['                regexprep(num2str(R_new.fit.AUC', 3), '\s+', ', ') ']'];
        str_title_param{2} = ['over ' R.F1.info.DV ' = [' regexprep(num2str([R.info.P1_LB, R.info.P1_UB], 2), '\s+', ', ') ']'];
    
    % for all other functions, construct the param title
    else
        R_new   = RPF_structArray2fieldMatrix(R);
        paramF1 = R_new.fit.params.F1;
        paramF2 = R_new.fit.params.F2;
        paramR  = paramF2 ./ paramF1;

        % set R title
        str_title_param{1} = ['\alpha_2 / \alpha_1 = ' regexprep(num2str(paramR(:,1)', 2),   '\s+', ', ')];
        str_title_param{2} = ['\beta_2 / \beta_1 = '   regexprep(num2str(paramR(:,2)', 2),   '\s+', ', ')];
        str_title_param{3} = ['AUC = ['                regexprep(num2str(R_new.fit.AUC', 3), '\s+', ', ') ']'];
        str_title_param{4} = ['over ' R.F1.info.DV ' = [' regexprep(num2str([R.info.P1_LB, R.info.P1_UB], 2), '\s+', ', ') ']'];

        str_title_AUC{1} = str_title_param{3};
        str_title_AUC{2} = str_title_param{4};
        
    end
    
end

end