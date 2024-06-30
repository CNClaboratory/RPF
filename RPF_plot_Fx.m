function h = RPF_plot_Fx(F, options, h)
% h = RPF_plot_Fx(F, options, h)

%% handle inputs

if ~exist('options', 'var')
    options = [];
end

options = RPF_plot_update_options(F, options);

% set i, which is used below as an index to options.F
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
x     = options.F{i}.x_min: .01: options.F{i}.x_max;
nCond = length(F.info.cond_vals);

% evaluate P = F(xt)
[P, xt] = RPF_eval_Fx(F, x);

% plot fit
for i_cond = 1:nCond
    plot(xt, P(i_cond, :), ...
         'LineStyle', options.F{i}.lineStyle{i_cond}, ...
         'LineWidth', options.F{i}.lineWidth{i_cond}, ...
         'Color', options.F{i}.lineColor(i_cond,:) );     

%     plot(F.fit(i_cond).xt_fn(x), ...
%          F.fit(i_cond).PF( F.fit(i_cond).params, F.fit(i_cond).xt_fn(x) ), ...
%          'LineStyle', options.F{i}.lineStyle{i_cond}, ...
%          'LineWidth', options.F{i}.lineWidth{i_cond}, ...
%          'Color', options.F{i}.lineColor(i_cond,:) );     
end

% plot data
for i_cond = 1:nCond
    xt = RPF_eval_xt_fn(F, F.data(i_cond).x);
    plot(xt, F.data(i_cond).P, ...
         'LineStyle', 'none', ...
         'Marker', options.F{i}.marker{i_cond}, ...
         'MarkerSize', options.F{i}.markerSize{i_cond}, ...
         'Color', options.F{i}.markerColor(i_cond,:) );

%     plot(F.fit(i_cond).xt_fn( F.data(i_cond).x ), ...
%          F.data(i_cond).P, ...
%          'LineStyle', 'none', ...
%          'Marker', options.F{i}.marker{i_cond}, ...
%          'MarkerSize', options.F{i}.markerSize{i_cond}, ...
%          'Color', options.F{i}.markerColor(i_cond,:) );
end


%% configure plot settings

% axis labels
xlabel(options.F{i}.str_x)
ylabel(options.F{i}.str_P)

% x-axis lmits
xlim(F.fit(1).xt_fn( [options.F{i}.x_min, options.F{i}.x_max] ))

% y-axis limits
yl = ylim;

if options.F{i}.set_P_lim_min
    yl(1) = options.F{i}.P_min;
end

if options.F{i}.set_P_lim_max
    yl(2) = options.F{i}.P_max;
end

ylim(yl);

% legend and title
if ~isempty(options.F{i}.str_legend)
    legend(options.F{i}.str_legend, 'location', 'best');
end

title(options.F{i}.str_title)
