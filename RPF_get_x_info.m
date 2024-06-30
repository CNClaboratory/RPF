function [x_vals_all, x_vals_with_defined_stimID] = RPF_get_x_info(trialData)
% [x_vals_all, x_vals_with_defined_stimID] = RPF_get_x_info(trialData)

f_x          = ~isnan(trialData.x) & ~isinf(trialData.x);
f_stimID_all = trialData.stimID == 0 | trialData.stimID == 1 | trialData.stimID == 0.5;
f_stimID_def = trialData.stimID == 0 | trialData.stimID == 1;

x_vals_all                 = unique(trialData.x(f_x & f_stimID_all));
x_vals_with_defined_stimID = unique(trialData.x(f_x & f_stimID_def));