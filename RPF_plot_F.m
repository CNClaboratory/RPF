function [h, plotSettings] = RPF_plot_F(F, plotSettings, h)
% [h, plotSettings] = RPF_plot_F(F, plotSettings, h)
%
% Create a plot of the psychometric function P = F(x).
%
% INPUTS
% ------
% * F - an F struct. see RPF_guide('F')
% * plotSettings - a struct controlling the appearance of the plot. 
%     - see RPF_guide('plotSettings') for a full description of settings
%       and default values
%     - any unspecified settings are set to their default values using
%       RPF_update_plotSettings
%     - if the plotSettings input is unspecified or empty, then all plot 
%       settings are set to their default values
% * h - a handle to the plot or subplot in which the F(x) plot will
%       be created. if empty or unspecified, a new figure is created.
%
% OUTPUTS
% -------
% * h            - a handle to the plot 
% * plotSettings - the updated plotSettings struct used to make the plot



%% handle inputs

if ~exist('plotSettings', 'var')
    plotSettings = [];
end

plotSettings = RPF_update_plotSettings(F, plotSettings);

% set i, which is used below as an index to plotSettings.F
if ~isfield(F, 'F_ind') || isempty(F.F_ind)
    i = 1;
else
    i = F.F_ind;
end

if ~exist('h', 'var') || isempty(h)
    h = figure;
end


%% plot P = F(x)

hold on;
x     = plotSettings.F{i}.x_min: .01: plotSettings.F{i}.x_max;
nCond = length(F.info.cond_vals);

% evaluate P = F(xt)
[P, xt] = RPF_eval_F(F, x);

% plot fit
for i_cond = 1:nCond
    plot(xt, P(i_cond, :), ...
         'LineStyle', plotSettings.F{i}.lineStyle{i_cond}, ...
         'LineWidth', plotSettings.F{i}.lineWidth(i_cond), ...
         'Color', plotSettings.F{i}.lineColor(i_cond,:) );     
end

% plot data
for i_cond = 1:nCond
    xt = RPF_eval_xt_fn(F, F.data(i_cond).x);
    plot(xt, F.data(i_cond).P, ...
         'LineStyle', 'none', ...
         'Marker', plotSettings.F{i}.marker{i_cond}, ...
         'MarkerSize', plotSettings.F{i}.markerSize(i_cond), ...
         'Color', plotSettings.F{i}.markerColor(i_cond,:) );
end


%% configure plot settings

% axis labels
xlabel(plotSettings.F{i}.str_x)
ylabel(plotSettings.F{i}.str_P)

% x-axis lmits
xlim(F.fit(1).xt_fn( [plotSettings.F{i}.x_min, plotSettings.F{i}.x_max] ))

% y-axis limits
yl = ylim;

if plotSettings.F{i}.set_P_lim_min
    yl(1) = plotSettings.F{i}.P_min;
end

if plotSettings.F{i}.set_P_lim_max
    yl(2) = plotSettings.F{i}.P_max;
end

ylim(yl);

% legend and title
if ~isempty(plotSettings.F{i}.str_legend)
    legend(plotSettings.F{i}.str_legend, 'location', 'best');
end

title(plotSettings.F{i}.str_title)
