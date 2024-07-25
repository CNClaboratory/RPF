function [h, plotSettings] = RPF_plot(F_or_R, plotSettings, PF_type)
% [h, plotSettings] = RPF_plot(F_or_R, plotSettings, PF_type)
%
% Create a plot of the psychometric functions F1 and/or F2 and/or R.
%
% INPUTS
% ------
% * F_or_R  - can be either an F struct or an R struct. 
% * plotSettings - a struct controlling the appearance of the plot. 
%     - see RPF_guide('plotSettings') for a full description of settings
%       and default values
%     - any unspecified settings are set to their default values using
%       RPF_update_plotSettings
%     - if the plotSettings input is unspecified or empty, then all plot 
%       settings are set to their default values
% * PF_type - a string specifying the type of PF to plot. 
%     - if the F_or_R input is an F struct, then PF_type is ignored and a 
%       plot of P = F(x) is produced using the information in F_or_R
%     - if the F_or_R input is an R struct, then PF_type specifies what
%       type of plot to produce using the information in R.
%       - 'F1'  -> make a plot of P1 = F1(x) using R.F1
%       - 'F2'  -> make a plot of P2 = F2(x) using R.F2
%       - 'R'   -> make a plot of P2 = R(P1)
%       - 'all' -> make a plot with 3 subplots for F1(x), F2(x), and R(P1)
%    - different plot types are created using the subfunctions RPF_plot_Fx
%      and RPF_plot_R
%    - default value of PF_type = 'all'
%
% OUTPUTS
% -------
% * h            - a handle to the plot 
% * plotSettings - the updated plotSettings struct used to make the plot

switch F_or_R.info.PF_type
    case 'F(x)'
        F    = F_or_R;
        isR  = 0;
        
    case 'R(P1)'
        R    = F_or_R;
        isR = 1;

        if ~exist('PF_type','var') || isempty(PF_type)
            PF_type = 'all';
        end
end

    
if isR
    switch PF_type
        case 'F1'
            [h, plotSettings] = RPF_plot_Fx(R.F1, plotSettings);
            
        case 'F2'
            [h, plotSettings] = RPF_plot_Fx(R.F2, plotSettings);
            
        case 'R'
            [h, plotSettings] = RPF_plot_R(R, plotSettings);
            
        case 'all'
            
            h  = figure;
            hs = subplot(1,3,1);
            RPF_plot_Fx(R.F1, plotSettings, hs);
            
            subplot(1,3,2);
            hs = subplot(1,3,2);
            RPF_plot_Fx(R.F2, plotSettings, hs);
            
            subplot(1,3,3);
            hs = subplot(1,3,3);
            [hh, plotSettings] = RPF_plot_R(R, plotSettings, hs);
            
            if isfield(plotSettings, 'str_sgtitle')
                sgtitle(plotSettings.str_sgtitle)
            end
    end
    
else
    [h, plotSettings] = RPF_plot_Fx(F, plotSettings);
    
end