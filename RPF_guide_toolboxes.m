% RPF_guide_toolboxes
%
% The RPF toolbox assumes installation of the following toolboxes:
% - Palamedes toolbox (www.palamedestoolbox.org)
% - Matlab optimization toolbox (www.mathworks.com/products/optimization.html)
% - meta-d' toolbox (www.columbia.edu/~bsm2105/type2sdt)
%   - this is included in the RPF toolbox in the folder "metad"
%
% These toolboxes are not necessary for every way of using the RPF toolbox,
% but they enable core functionality:
% - Palamedes toolbox enables working with many basic psychometric functions
%   (see RPF_get_PF_list('PFs_Palamedes') for a listing) and performing MLE
%   fits on PFs fitted to response probablities
% - optimization toolbox enables performing MLE fits on d' and meta-d'
% - meta-d' toolbox enables meta-d' analysis
%
% To check if the RPF toolbox can detect the presence of these supporting
% toolboxes, use the function RPF_check_toolboxes