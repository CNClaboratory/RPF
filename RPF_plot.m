function h = RPF_plot(F_or_R, options, plot_type)
% h = RPF_plot(F_or_R, options, plot_type)

% F -> must plot F, default to F1/P1 settings in options
% R -> can plot F1, F2, R, or all, specify in

switch F_or_R.info.PF_type
    case 'F(x)'
        F    = F_or_R;
        isR  = 0;
        
        if ~exist('plot_type','var') || isempty(plot_type)
            plot_type = 'F1';
        end
        
    case 'R(P1)'
        R    = F_or_R;
        isR = 1;

        if ~exist('plot_type','var') || isempty(plot_type)
            plot_type = 'all';
        end
end

    
if isR
    switch plot_type
        case 'F1'
            h = RPF_plot_Fx(R.F1, options);
            
        case 'F2'
            h = RPF_plot_Fx(R.F2, options);
            
        case 'R'
            h = RPF_plot_R(R, options);
            
        case 'all'
            
            h  = figure;
            hs = subplot(1,3,1);
            RPF_plot_Fx(R.F1, options, hs);
            
            subplot(1,3,2);
            hs = subplot(1,3,2);
            RPF_plot_Fx(R.F2, options, hs);
            
            subplot(1,3,3);
            hs = subplot(1,3,3);
            RPF_plot_R(R, options, hs);
            
            if isfield(options, 'str_sgtitle')
                sgtitle(options.str_sgtitle)
            end
    end
    
else
    h = RPF_plot_Fx(F, options);
    
end