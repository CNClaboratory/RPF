function h = RPF_plot_R(R, options, h)
% h = RPF_plot_R(R, options)

%% handle inputs

if~exist('options', 'var')
    options = [];
end

options = RPF_plot_update_options(R, options);

if ~exist('h', 'var') || isempty(h)
    h = figure;
end


%% plot P2 = R(P1) fits

hold on;
nCond = length(R.info.cond_vals);
x     = options.R.x_min: .01: options.R.x_max;

for i_cond = 1:nCond

    if isfield(R.info, 'PF') && isa(R.info.PF, 'function_handle') && strcmp('RPF_interp_RPF', func2str(R.info.PF))
        P1_grain = 1e-4;
%         P1fit  = R.info.max_P1_at_x_min : P1_grain : R.info.min_P1_at_x_max;
%         P2fits = RPF_interp_RPF(R, P1fit);
%         P2fit  = P2fits(i_cond, :);

%         P1fit = R.fit(i_cond).params.P1_sorted_unique(1) : P1_grain : R.fit(i_cond).params.P1_sorted_unique(end);
        P1fit = linspace(R.fit(i_cond).params.P1_sorted_unique(1), R.fit(i_cond).params.P1_sorted_unique(end), 1000);
        P2fit = interp1(R.fit(i_cond).params.P1_sorted_unique, ...
                        R.fit(i_cond).params.P2_sorted_unique, ...
                        P1fit, ...
                        R.fit(i_cond).params.interp_method);        
        
    else
        
%         P1fit = RPF_eval(F1, x); 
%         P1fit = RPF_eval(F1.fit(i_cond), x); 
%         R.F1.fit(i_cond).PF( R.F1.fit(i_cond).params, R.F1.fit(i_cond).x_transform(x) );
        
        P1fit = R.F1.fit(i_cond).PF( R.F1.fit(i_cond).params, R.F1.fit(i_cond).xt_fn(x) );
        P2fit = R.F2.fit(i_cond).PF( R.F2.fit(i_cond).params, R.F2.fit(i_cond).xt_fn(x) );
    end
    
    plot(P1fit, P2fit, ...
         'LineStyle', options.R.lineStyle{i_cond}, ...
         'LineWidth', options.R.lineWidth{i_cond}, ...
         'Color', options.R.lineColor(i_cond,:) );     
     
%     plot(R.F1.fit(i_cond).PF( R.F1.fit(i_cond).params, R.F1.fit(i_cond).x_transform(x) ), ...
%          R.F2.fit(i_cond).PF( R.F2.fit(i_cond).params, R.F2.fit(i_cond).x_transform(x) ), ...
%          options.style_fit{i_cond});

end


%% plot P2 = R(P1) data

for i_cond = 1:nCond
    
    if isfield(R.info, 'PF') && isa(R.info.PF, 'function_handle') && strcmp('RPF_interp_RPF', func2str(R.info.PF))
        P1data = R.fit(i_cond).params.P1_sorted_unique;
        P2data = R.fit(i_cond).params.P2_sorted_unique;
        
    else
        % check for consistency in number of data points in F1 and F2;
        % these can differ if the data set includes an x_min value at which
        % one of the functions is defined and the other is not, e.g.
        % p(correct) being undefined in a grating discrimination task when
        % contrast = 0 but RT and rating still having defined values
        if length(R.F1.data(i_cond).P) == length(R.F2.data(i_cond).P)
            P1data = R.F1.data(i_cond).P;
            P2data = R.F2.data(i_cond).P;
        
        elseif length(R.F1.data(i_cond).P) < length(R.F2.data(i_cond).P)
            if R.F1.data(i_cond).x(1) ~= 0 && R.F2.data(i_cond).x(1) == 0
                P1data = R.F1.data(i_cond).P;
                P2data = R.F2.data(i_cond).P(2:end);
                
                P1data_at_x0 = R.F1.info.P_min;
                P2data_at_x0 = R.F2.data(i_cond).P(1);

            else
                error('F1 and F2 do not have equal numbers of data points')
            end
            
        elseif length(R.F2.data(i_cond).P) < length(R.F1.data(i_cond).P)
            if R.F1.data(i_cond).x(1) == 0 && R.F2.data(i_cond).x(1) ~= 0
                P1data = R.F1.data(i_cond).P(2:end);
                P2data = R.F2.data(i_cond).P;
                
                P1data_at_x0 = R.F1.data(i_cond).P(1);
                P2data_at_x0 = R.F2.info.P_min;

            else
                error('F1 and F2 do not have equal numbers of data points')
            end            
        end
    end
    
    plot(P1data, P2data, ...
         'LineStyle', 'none', ...
         'Marker', options.R.marker{i_cond}, ...
         'MarkerSize', options.R.markerSize{i_cond}, ...
         'Color', options.R.markerColor(i_cond,:) );

    
    if exist('P1data_at_x0','var') && exist('P2data_at_x0','var')
        plot(P1data_at_x0, P2data_at_x0, ...
            'LineStyle', 'none', ...
            'Marker', options.R.marker_partial{i_cond}, ...
            'MarkerSize', options.R.markerSize_partial{i_cond}, ...
            'Color', options.R.markerColor_partial(i_cond,:) );
    end    
    
%     plot(R.F1.data(i_cond).P, R.F2.data(i_cond).P, options.style_data{i_cond});

end


%% configure plot settings

% axis labels
xlabel(options.F{1}.str_P)
ylabel(options.F{2}.str_P)


% x-axis limits
xl = xlim;

if options.F{1}.set_P_lim_min
    xl(1) = options.F{1}.P_min;
end

if options.F{1}.set_P_lim_max
    xl(2) = options.F{1}.P_max;
end

xlim(xl);


% y-axis limits
yl = ylim;

if options.F{2}.set_P_lim_min
    yl(1) = options.F{2}.P_min;
end

if options.F{2}.set_P_lim_max
    yl(2) = options.F{2}.P_max;
end

ylim(yl);


% shading AUC region
if options.R.shade_overlap
    yl = ylim;

    area([R.info.P1_LB, R.info.P1_UB], yl(2)*[1,1], yl(1), ...
        'EdgeColor', options.R.shade_color, ...
        'EdgeAlpha', options.R.shade_alpha, ...
        'FaceColor', options.R.shade_color, ...
        'FaceAlpha', options.R.shade_alpha);
end


% plot meta-d' vs d' for reference if applicable
if (strcmp(R.F1.info.DV, 'd''') && strcmp(R.F2.info.DV, 'meta-d''')) || ...
   (strcmp(R.F1.info.DV, 'meta-d''') && strcmp(R.F2.info.DV, 'd'''))
    xl = xlim;
    plot(xl, xl, 'k--')
end


% legend and title
if ~isempty(options.R.str_legend)
    legend(options.R.str_legend, 'location', 'best');
end

title(options.R.str_title)
