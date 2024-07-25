% RPF_guide_trialData
%
% Description of the trialData struct used in the RPF toolbox. 
% 
% trialData is a struct whose fields contain trial-by-trial data from an
% experiment. It is used to help define default values of the info struct
% in RPF_update_Fx_info, and to compute the summary data in RPF_get_Fx_data. 
% This summary data is what is used for fitting the psychometric function
% in RPF_fit_Fx_data.
%
% trialData can contain the fields listed below, all of which are 1 x nTrials 
% vectors holding trial-by-trial data. Of these fields, only x and stimID 
% are mandatory. response, rating, and RT are optional depending on the 
% desired DV for analysis. condition is also not required if the experiment 
% had no conditions other than stimulus strength.
% 
% trialData.x
%   - stimulus strength on each trial, specified in raw (non-transformed) 
%     units of measurement
%   - these should be defined such that x = 0 corresponds to the minimum
%     possible stimulus strength at which chance rates of performance
%     occur, since psychometric functions such as the Weibull assume this
%     behavior. 
%     - if your x data do not have x = 0 as the minimum value correspoding to 
%       chance-level performace, you should transform your x values PRIOR TO 
%       entry to the RPF toolbox, so that psychometric function fits on 
%       untransformed x values will yield chance-level responding at x = 0 as 
%       intended. 
%     - for instance, if your x data are in the form of a ratio with 1 as the 
%       minimum value, consider a transformation that converts x = 1 to x = 0, 
%       e.g. log10(x). note that this transformation would be applied PRIOR TO 
%       any subsequent transformations of x managed by the RPF toolbox using 
%       info.xt_fn (see below)
%   - if transformations to the raw x values, such as log10(x), are desired, 
%     these are handled by specifying the transformation function info.xt_fn 
%     in accordance with the appropriate corresponding psychometric function 
%     as specified in info.PF (see RPF_guide('info'))
%
% trialData.stimID
%   - objective identity of the stimulus on each trial, using this coding:
%     0 = S1 stimulus, 1 = S2 stimulus, 0.5 = S1 vs S2 classification is N/A
%   - for instance, in a grating tilt discrimination task, S1 and S2 might
%     mean "left tilt" and "right tilt" respectively
%   - or, in a grating detection task, S1 and S2 might mean "grating absent" 
%     and "grating present" respectively
%   - for discrimination tasks, the stimulus identity may be undefined when
%     x = 0. for instance, in a grating tilt discrimination task where x is
%     grating contrast, grating tilt is undefined at x = 0 since no grating
%     is physically present when contrast = 0. in such cases, trialData.stimID 
%     should be set to 0.5 to indicate that the stimulus cannot be defined
%     as either S1 or S2. this indicates to the toolbox that accuracy
%     measures such as d' cannot be computed for such trials, although 
%     non-accuracy measures such as p(high rating) can be.
%     - accuracy measures include p(correct), d', meta-d', and type 2 AUC
%     - non-accuracy measures include p(response), p(high rating), mean 
%       rating, and RT
%
% trialData.response
%   - subject's stimulus classification response on each trial, using this 
%     coding: 0 = responded "S1", 1 = responded "S2"
%
% trialData.rating
%   - subject's rating of confidence or awareness on each trial, measured on 
%     an ordinal scale from 1 to nRatings
%
% trialData.condition 
%   - experimental condition on each trial. this must be specified using a 
%     numeric label, e.g. 1 or 2
%
% trialData.RT
%   - reaction time on each trial
