function RPF_check_toolboxes
% RPF_check_toolboxes
%
% Checks the current path for Palamedes, meta-d', and optimization
% toolboxes, and prints a notification of any missing toolboxes to the 
% Matlab prompt.

%% 

allFound = 1;

%% check for Palamedes toolbox

if ~exist('PAL_version', 'file') || ~exist('PAL_Weibull', 'file')
    fprintf(['---------------------------\n' ...
             'Palamedes toolbox not found\n' ...
             '---------------------------\n' ...
             'The RPF toolbox requires installation of the Palamedes toolbox to run properly.\n' ... 
             'Please add the Palamedes toolbox to your Matlab path.\n' ...
             'To download the Palamedes toolbox, see www.palamedestoolbox.org\n\n'])
    
    allFound = 0;
end


%% check for meta-d' toolbox

if ~exist('fit_meta_d_MLE', 'file') || ~exist('fit_rs_meta_d_MLE', 'file')
    
    % try adding metad folder in current directory
    addpath('metad');

    if ~exist('fit_meta_d_MLE', 'file') || ~exist('fit_rs_meta_d_MLE', 'file')
        fprintf(['---------------------------\n' ...
                 'meta-d'' toolbox not found\n' ...
                 '---------------------------\n' ...
                 'The RPF toolbox requires installation of the meta-d'' toolbox to conduct meta-d'' analysis.\n' ... 
                 'Please add the folder named "metad" contained in the RPF toolbox folder to your Matlab path.\n\n'])
    else
         warning('RPF:pathAdded', ['\nmeta-d'' toolbox added to path\n\n' ...
                                   'The meta-d'' toolbox has been added to the Matlab path to ensure proper functioning ' ...
                                   'of the RPF toolbox.\n'])
    end
    
    allFound = 0;
end


%% check for optimization toolbox

if ~exist('fmincon', 'file')
    fprintf(['------------------------------\n' ...
             'Optimization toolbox not found\n' ...
             '------------------------------\n' ...
             'The RPF toolbox requires installation of the Optimization toolbox to run properly.\n' ... 
             'Without this toolbox, MLE fitting is not available for certain DVs.\n\n'])
         
    allFound = 0;
end

%% 

if allFound
    disp('All toolboxes found!')
end