% RPF_guide_F
%
% Description of the F struct used in the RPF toolbox. 
%
% The F struct contains information about fits of psychometric functions to
% data across experimental conditions for a specified dependent variable in
% the form P = F(x), where P denotes performance on the dependent variable
% and x denotes stimulus strength. For information on how to construct the
% F struct, see RPF_guide('workflow').
%
% F contains the following fields:
%
% F.info
%   - a struct containing information on how to conduct data analysis and
%     function fitting
%   - see RPF_guide('info') for more information
%
% F.data(i_cond)
%   - a struct array containing analysis of the data in the trialData
%     struct (see RPF_guide('trialData')) as specified by the info struct
%   - produced by the function RPF_get_Fx_data
%   - see RPF_guide('data') for more information
%
% F.fit(i_cond)
%   - a struct array containing information on the fits to the data in
%     F.data(i_cond) as specified in the info struct
%   - produced by the function RPF_fit_Fx
%   - see RPF_guide('fit') for more information