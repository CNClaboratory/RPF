function trialData_f = RPF_filter_trialData(trialData, nRatings, cond_val, DV_respCond, exclude_undef_stimID)
% trialData_f = RPF_filter_trialData(trialData, nRatings, cond_val, DV_respCond, exclude_undef_stimID)
%
% Filter the trialData struct for subsequent analysis. 
%
% This function filters out improperly defined trials from the trialData
% struct (see RPF_guide('trialData')) so that only trials conforming to the
% following format are included in the output trialData_f:
%
% - trialData.stimID == 0, 0.5, or 1
% - trialData.response == 0 or 1
% - trialData.rating >= 1 and <= nRatings
%
% Additional filter settings may be applied depending on the optional inputs, 
% as specified below.
%
% INPUTS
% ------
% trialData - the trialData struct. see RPF_guide('trialData')
% nRatings  - number of available ratings in the rating scale
%
% OPTIONAL INPUTS
% ---------------
% cond_val - filter trials according to condition value, such that only
%    trials satisfying trialData.condition == cond_val are included in the
%    output trialData_f
%
% DV_respCond - filter trials according to response, such that
%    DV_respCond = "rS1" -> only trials satisfying trialData.response == 0
%       are included in the output trialData_f 
%    DV_respCond = "rS2" -> only trials satisfying trialData.response == 1
%       are included in the output trialData_f 
%
% exclude_undef_stimID - if set to 1, filter out trials with undefined stimID
%    (coded as stimID == 0.5), such that only trials satisfying
%    trialData.stimID == 0 or 1 are included in the output trialData_f
%
% OUTPUT
% ------
% trialData_f - the result of applying the filter settings to trialData


%% define trial filter f

d = trialData;

f_x = ~isnan(d.x) & ~isinf(d.x);

if exist('exclude_undef_stimID', 'var') && exclude_undef_stimID == 1
    f_stimID = d.stimID == 0 | d.stimID == 1;    
else
    f_stimID = d.stimID == 0 | d.stimID == 1 | d.stimID == 0.5;
end

if exist('DV_respCond', 'var') && strcmp(DV_respCond, 'rS1')
    f_resp = d.response == 0;
elseif exist('DV_respCond', 'var') && strcmp(DV_respCond, 'rS2')
    f_resp = d.response == 1;
else
    f_resp = d.response == 0 | d.response == 1;
end

f = f_x & f_stimID & f_resp;

if isfield(d, 'rating')
    f_rating = d.rating >=1 & d.rating <= nRatings;
    f        = f & f_rating;
end

if isfield(d, 'condition') && exist('cond_val', 'var')
    f_cond = d.condition == cond_val;
    f      = f & f_cond;
end

% if isfield(d, 'RT')
%     f_RT = ~isnan(d.RT) & ~isinf(d.RT);
%     f = f & f_RT;
% end

%% filter the data

trialData_f.x        = trialData.x(f);
trialData_f.stimID   = trialData.stimID(f);
trialData_f.response = trialData.response(f);

if isfield(d, 'rating')
    trialData_f.rating = trialData.rating(f);
end

if isfield(d, 'RT')
    trialData_f.RT = trialData.RT(f);
end    