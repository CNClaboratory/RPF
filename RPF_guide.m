function RPF_guide(query)
% RPF_guide(query)
%
% Get information and guidance on different aspects of the RPF toolbox.
%
% Different values of the query input give guidance on the following topics:
%
% general topics
% 'toolboxes'    -> on toolboxes that enable full functionality for the RPF toolbox
% 'workflow'     -> on the general workflow of using the RPF toolbox
% 'utilities'    -> on utilities and helper functions in the RPF toolbox
%
% main structs used in the RPF toolbox
% 'trialData'    -> on the trialData struct (specified by the user)
% 'info'         -> on the info struct (partially specified by the user)
% 'constrain'    -> on the constrain struct (specified by the user)
% 'data'         -> on the data struct (produced by RPF_get_F_data)
% 'fit'          -> on the fit struct (produced by RPF_fit_F)
% 'F'            -> on the F struct (assembled in the toolbox workflow)
% 'R'            -> on the R struct (produced by RPF_get_R)
% 'plotSettings' -> on the plotSettings struct (used with RPF_plot)
%
% secondary structs used in the RPF toolbox
% 'counts'       -> on the counts struct (used for SDT analysis)
% 'padInfo'      -> on cell padding used for computing the counts struct
% 'searchGrid'   -> on the searchGrid used in PF fitting
%
% To view the documentation for a given query in a file editor rather than 
% the Matlab prompt, open the file "RPF_guide_(query).m". For instance, for
% the query 'info', the documentation can be viewed in the file
% "RPF_guide_info.m".

if nargin == 0, query = ''; end

switch query
    case ''
        help RPF_guide
        
    case 'toolboxes'
        help RPF_guide_toolboxes

    case 'workflow'
        help RPF_guide_workflow
        
    case 'utilities'
        help RPF_guide_utilities
        
    case 'trialData'
        help RPF_guide_trialData
        
    case 'info'
        help RPF_guide_info
        
    case 'constrain'
        help RPF_guide_constrain
    
    case 'data'
        help RPF_guide_data
        
    case 'fit'
        help RPF_guide_fit
        
    case 'F'
        help RPF_guide_F
        
    case 'R'
        help RPF_guide_R

    case 'plotSettings'
        help RPF_guide_plotSettings
        
    case 'counts'
        help RPF_guide_counts
        
    case 'padInfo'
        help RPF_guide_padInfo
        
    case 'searchGrid'
        help RPF_guide_searchGrid
end