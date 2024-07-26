% RPF_guide_workflow
%
% In the RPF toolbox, one can fit psychometric functions relating performance 
% for two outcome measures P1 and P2 to stimulus strength x across multiple 
% experimental conditions via the functions P1 = F1(x) and P2 = F2(x). With 
% these fits, one can then analyze the relative psychometric function or RPF 
% relating P2 directly to P1, expressed as P2 = R(P1). Various options are 
% provided for behavioral data analysis and fitting or interpolating the data.
%
% The RPF toolbox assumes installation of a few supporting toolboxes. These
% are not strictly necessary to use the RPF toolbox, but they do enable
% core aspects of its functionality. For more, see RPF_guide('toolboxes').
%
% WORKFLOW
% --------
% The general workflow of the RPF toolbox is as follows:
%
% ORGANIZING THE TRIAL-BY-TRIAL DATA
%
% 1. Format your behavioral data in the trialData struct
%    - see RPF_guide('trialData') for details
%
% PSYCHOMETRIC FUNCTION ANALYSIS FOR F1 AND F2
%
% 2. Specify any desired analysis settings for the F1(x) analysis in the 
%    info struct
%    - see RPF_guide('info') for details
%
% 3. Analyze trialData and fit a psychometric function to the data
%    according to the specifications in info using RPF_get_F
%    - see RPF_guide('F') for details
%
% 4. Repeat steps 2-3 for the F2(x) analysis
%
% RELATIVE PSYCHOMETRIC FUNCTION ANALYSIS
%
% 5. Produce the R struct from F1 and F2 using RPF_get_R
%    - see RPF_guide('R') for details
%
% 6. R already contains AUC analysis over the maximal possible range of P1
%    values, but subsequent AUC analysis using different ranges for P1 can
%    be done using RPF_AUC
%
% 7. Flexibly plot the results of F1, F2, and/or R using RPF_plot, with
%    optional plot customization specified using the plotSettings struct
%    - see RPF_guide('plotSettings') for details
%
% MANUAL DEFINITION OF DATA
%
% If you do not have access to trial-by-trial data or the available options
% for working with trialData are not sufficient for your use case, you may
% manually define the values of the data struct rather than generating
% these with the RPF toolbox code. If using this option, be sure to consult
% RPF_guide('info') and RPF_guide('data') for a listing of the fields of the 
% info and data structs that you may need to manually define such that
% these variables are formatted the way the toolbox expects them to be.
%
% EXAMPLE ANALYSIS SCRIPTS
% ------------------------
% Consult the example analysis scripts for see fully worked examples and 
% to begin exploring available analysis and plotting options.
%
% RPF_example_simple
% - this contains a simple predefined analysis on an example data set to 
%   help you get a feel for the toolbox workflow 
%
% RPF_example_flexible
% - this is a more detailed script that is set up in a way that allows you 
%   to quickly play with different analysis settings on the example data set