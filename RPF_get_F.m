function F = RPF_get_F(info, trialData)
% F = RPF_get_F(info, trialData)
%
% Create an F struct from trialData using the specifications in info.
%
% INPUTS
% ------
% info      - the info struct. see RPF_guide('info') for more
% trialData - the trialData struct. see RPF_guide('trialData') for more
%
% OUTPUTS
% -------
% F - the F struct. see RPF_guide('F') for more

F.info = RPF_update_info(info, trialData);

F.data = RPF_get_F_data(F.info, trialData);

F.fit = RPF_fit_F(F.info, F.data);