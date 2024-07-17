function [h, options] = RPF_plot(F_or_R, options, plot_type)
% [h, options] = RPF_plot(F_or_R, options, plot_type)
%
% Create a plot of the psychometric functions F1 and/or F2 and/or R.
%
% INPUTS
% ------
% * F_or_R  - can be either an F struct or an R struct. 
% * options - a struct containing options for controlling the appearance of 
%             the plot. see "help RPF_plot_update_options" for a full listing of
%             options. any unspecified settings are set to their default values
%             with RPF_plot_update_options. if the options input is unspecified 
%             or empty, then all plot settings are set to their default values.
% * plot_type - a string specifying the plot type. 
%     - if the F_or_R input is an F struct, then plot_type is ignored and a 
%       plot of P = F(x) is produced using the information in F_or_R
%     - if the F_or_R input is an R struct, then plot_type specifies what
%       type of plot to produce using the information in R.
%       - 'F1'  -> make a plot of P1 = F1(x) using R.F1
%       - 'F1'  -> make a plot of P2 = F2(x) using R.F2
%       - 'R'   -> make a plot of P2 = R(P1)
%       - 'all' -> make a plot with 3 subplots for F1(x), F2(x), and R(P1)
%    - different plot types are created using the subfunctions RPF_plot_Fx
%      and RPF_plot_R
%    - default value of plot_type = 'all'
%
% OUTPUTS
% -------
% * h       - a handle to the plot 
% * options - the updated options struct used to make the plot

switch F_or_R.info.PF_type
    case 'F(x)'
        F    = F_or_R;
        isR  = 0;
        
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
            [h, options] = RPF_plot_Fx(R.F1, options);
            
        case 'F2'
            [h, options] = RPF_plot_Fx(R.F2, options);
            
        case 'R'
            [h, options] = RPF_plot_R(R, options);
            
        case 'all'
            
            h  = figure;
            hs = subplot(1,3,1);
            RPF_plot_Fx(R.F1, options, hs);
            
            subplot(1,3,2);
            hs = subplot(1,3,2);
            RPF_plot_Fx(R.F2, options, hs);
            
            subplot(1,3,3);
            hs = subplot(1,3,3);
            [hh, options] = RPF_plot_R(R, options, hs);
            
            if isfield(options, 'str_sgtitle')
                sgtitle(options.str_sgtitle)
            end
    end
    
else
    [h, options] = RPF_plot_Fx(F, options);
    
end