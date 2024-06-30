% RPF toolbox
%
% In this toolbox one can fit psychometric functions relating behavioral
% performance for two outcome measures, P1 and P2, to stimulus strength x,
% via the functions P1 = F1(x) and P2 = F2(x), across multiple experimental 
% conditions. With these fits, one can then analyze the relative psychometric 
% function or RPF relating P2 directly to P1, expressed as P2 = R(P1). 
% Various options are provided for behavioral data analysis and fitting or 
% interpolating the data.
%
% the general workflow of the toolbox is as follows:
% 1. format your behavioral data in accordance with the description of the
%    trialData struct in the help comments for RPF_get_Fx_data 
% 2. manually define important analysis and variable settings for the F1(x) 
%    analysis in the info struct; see the help comments for RPF_info for
%    more details
% 3. use RPF_update_Fx_info to update the info struct
% 4. use RPF_get_Fx_data to analyze the data in preparation for fitting / 
%    interpolating
% 5. use RPF_fit_Fx to run the fit / interpolation
% 6. repeat steps 2-5 for the F2(x) analysis
% 6. use RPF_get_R to obtain a combined struct for RPF analysis and
%    plotting
% 7. compute RPF AUCs with RPF_AUC
% 8. plot the results with RPF_plot
%
% example analysis scripts
% - see RPF_example_simple for a simple predefined analysis on an example
%   data set to help you get a feel for the toolbox workflow 
% - see RPF_example_flexible for a more detailed script allowing you 
%   to quickly play with different analysis settings on the example data
%   set
%
% Please note that not all scripts and functions have completely up to date
% comments yet. Please refer to the following comments to help guide you in
% your use of the toolbox, and if anything is unclear, email
% bmaniscalco@gmail.com
% - "help RPF_info" -> essential information for how to set up the info
%   structs used in the RPF toolbox workflow. Please read these comments
%   carefully before conducting your analysis, and cross reference with the
%   examples in RPF_example_simple and RPF_example_flexible to get a feel 
%   for how to use the info struct in your workflow.
% - "help RPF_get_Fx_data" -> Refer to the comments here for info on how to
%   set up your trialData struct in the format expected by the toolbox.
% - The above are the main comments you need to set up the basics of your 
%   analysis, but if helpful the following main functions also have updated 
%   comments:
%    - RPF_fit_Fx
%    - RPF_get_R
%    - RPF_AUC