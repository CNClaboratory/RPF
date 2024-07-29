function [counts, padInfo] = RPF_trials2counts_SDT(trialData, info)
% [counts, padInfo] = RPF_trials2counts_SDT(trialData, info)
%
% Produce response counts as a function of various conditions for use with
% SDT analysis.
%
% INPUTS
% ------
% info - a struct holding settings for data analysis. see RPF_guide('info') 
% 
% trialData - a struct holding trial-by-trial data from an experiment. see
%    RPF_guide('trialData')
%
% OUTPUTS
% -------
% counts - a struct holding counts for SDT analysis. see RPF_guide('counts') 
%
% padInfo - a struct holding information on the cell padding settings used
%    in the calculation of counts. see RPF_guide('padInfo')


%% sort inputs

% insert dummy rating data if none exist
if ~isfield(trialData, 'rating')
    trialData.rating = ones(size(trialData.x));
    info.nRatings    = 1;
end

% check for valid inputs
if ~( all( length(trialData.x) == [length(trialData.stimID), length(trialData.response), length(trialData.rating)] ) ) 
    error('x, stimID, response, and rating input vectors must have the same length')
end

% filter bad trials
trialData = RPF_filter_trialData(trialData, info.nRatings);

% check for valid padding settings
if ~isfield(info, 'padCells') || isempty(info.padCells)
    error('RPF:invalidOption', ['\ninfo.padCells has not been defined, which precludes SDT analysis.\n' ...
                                'See "help RPF_info" for how to configure the info struct.'])
end

if ~isfield(info, 'padAmount') || isempty(info.padAmount)
    error('RPF:invalidOption', ['\ninfo.padAmount has not been defined, which precludes SDT analysis.\n' ...
                                'See "help RPF_info" for how to configure the info struct.'])
end


%% unpack struct fields

x        = trialData.x;
stimID   = trialData.stimID;
response = trialData.response;
rating   = trialData.rating;

nRatings = info.nRatings;
x_vals   = info.x_vals;
nx       = length(x_vals);


%% determine counts format depending on task type

if all(stimID(x==min(x))==0) && all(stimID(x > min(x))==1)
    task_type = 'detect x';
else
    task_type = 'discriminate at x';
end


%% compute response counts

nR_S1 = [];
nR_S2 = [];

switch task_type
    case 'detect x'

        for i_x = 1 : nx
            
            % S1 responses
            i_r = 0;

            for r = nRatings : -1 : 1
                i_r = i_r + 1;
                
                if i_x == 1
                    nR_S1(i_r)        = sum(x==x_vals(i_x) & stimID==0 & response==0 & rating==r);
                else
                    nR_S2(i_x-1, i_r) = sum(x==x_vals(i_x) & stimID==1 & response==0 & rating==r);
                end
            end

            % S2 responses
            for r = 1 : nRatings
                i_r = i_r + 1;
                
                if i_x == 1
                    nR_S1(i_r)        = sum(x==x_vals(i_x) & stimID==0 & response==1 & rating==r);
                else
                    nR_S2(i_x-1, i_r) = sum(x==x_vals(i_x) & stimID==1 & response==1 & rating==r);
                end
            end

        end
        
    case 'discriminate at x'

        for i_x = 1 : nx

            % S1 responses
            i_r = 0;

            for r = nRatings : -1 : 1
                i_r = i_r + 1;
                nR_S1(i_x, i_r) = sum(x==x_vals(i_x) & stimID==0 & response==0 & rating==r);
                nR_S2(i_x, i_r) = sum(x==x_vals(i_x) & stimID==1 & response==0 & rating==r);
            end

            % S2 responses
            for r = 1 : nRatings
                i_r = i_r + 1;
                nR_S1(i_x, i_r) = sum(x==x_vals(i_x) & stimID==0 & response==1 & rating==r);
                nR_S2(i_x, i_r) = sum(x==x_vals(i_x) & stimID==1 & response==1 & rating==r);
            end

        end
end


%% determine padInfo

% nTrialsPerX = max( [sum(nR_S1, 2)', sum(nR_S2, 2)'] );

% take nTrialsPerX_Si to be the number of trials for which a valid response
% was recorded (as reflected in nR_Si) that is maximal across levels of
% stimulus strength x
nTrialsPerX_S1 = max( sum(nR_S1, 2) ); 
nTrialsPerX_S2 = max( sum(nR_S2, 2) );


if info.padCells_correctForTrialCounts
    
    if nTrialsPerX_S1 > nTrialsPerX_S2
        padAmount_S1 = info.padAmount;
        padAmount_S2 = info.padAmount * (nTrialsPerX_S2 / nTrialsPerX_S1);
    else
        padAmount_S2 = info.padAmount;
        padAmount_S1 = info.padAmount * (nTrialsPerX_S1 / nTrialsPerX_S2);        
    end
    
else
    padAmount_S1 = info.padAmount;
    padAmount_S2 = info.padAmount;
end

padAmount_nonzero_d = info.padAmount_nonzero_d;

% package padInfo struct
padInfo.padCells                       = info.padCells;
padInfo.padCells_correctForTrialCounts = info.padCells_correctForTrialCounts;
padInfo.padCells_nonzero_d             = info.padCells_nonzero_d;

padInfo.nTrialsPerX_S1                 = nTrialsPerX_S1;
padInfo.nTrialsPerX_S2                 = nTrialsPerX_S2;

padInfo.padAmount                      = info.padAmount;
padInfo.padAmount_S1                   = padAmount_S1;
padInfo.padAmount_S2                   = padAmount_S2;
padInfo.padAmount_nonzero_d            = info.padAmount_nonzero_d;


%% apply response padding

% optinally apply padding to prevent zeros in nR_S1 and nR_S2, since this 
% interferes with estimation of d' and meta-d'.
% 
% this padding works by adding padAmount_Si to all cells of nR_Si,
% thereby preventing any zero counts that could interfere with
% calculation of d' and meta-d'.
if padInfo.padCells
    nR_S1 = nR_S1 + padAmount_S1;
    nR_S2 = nR_S2 + padAmount_S2;
end

% optionally apply padding to prevent d' = 0, since meta-d' is undefined when d' = 0.
% 
% this padding works by adding a very small amount padAmount_nonzero_d
% to all trials in which the stimulus was S1 and the response was "S1"
% (correct rejections), and all trials in which the stimulus was S2 and the
% response was "S2" (hits), thereby adding a balanced amount to S1 and S2
% response counts that prevents values of d'=0.
if padInfo.padCells_nonzero_d
    nR_S1(:, 1 : nRatings)     = nR_S1(:, 1 : nRatings)     + padAmount_nonzero_d;
    nR_S2(:, nRatings+1 : end) = nR_S2(:, nRatings+1 : end) + padAmount_nonzero_d;
end


%% compute min and max FAR, HR, d' given padding settings

% max HR occurs when all S2 trials are hits
HR_pad_max  = (nTrialsPerX_S2 +     padAmount_S2 * nRatings + padAmount_nonzero_d * nRatings) / ...
              (nTrialsPerX_S2 + 2 * padAmount_S2 * nRatings + padAmount_nonzero_d * nRatings);

% min HR occurs when no S2 trials are hits
HR_pad_min  = (                     padAmount_S2 * nRatings + padAmount_nonzero_d * nRatings) / ...
              (nTrialsPerX_S2 + 2 * padAmount_S2 * nRatings + padAmount_nonzero_d * nRatings);

% max FAR occurs when all S1 trials are FAs
FAR_pad_max = (nTrialsPerX_S1 +     padAmount_S1 * nRatings) / ...
              (nTrialsPerX_S1 + 2 * padAmount_S1 * nRatings + padAmount_nonzero_d * nRatings);

% min FAR occurs when no S1 trials are FAs
FAR_pad_min = (                     padAmount_S1 * nRatings) / ...
              (nTrialsPerX_S1 + 2 * padAmount_S1 * nRatings + padAmount_nonzero_d * nRatings);
          
padInfo.HR_pad_min  = HR_pad_min;
padInfo.HR_pad_max  = HR_pad_max;
padInfo.FAR_pad_min = FAR_pad_min;
padInfo.FAR_pad_max = FAR_pad_max;

padInfo.d_pad_max   = norminv( HR_pad_max ) - norminv( FAR_pad_min );
padInfo.d_pad_min   = norminv( HR_pad_min ) - norminv( FAR_pad_min );


%% express SDT counts in type 2 format

switch task_type
    case 'detect x'

        % correct "S1" and incorrect "S2" responses for S1 stimuli, 
        % which occur at x == 0
        nC_rS1 = nR_S1(1 : nRatings);
        nI_rS2 = nR_S1(nRatings+1 : end);
        
        % incorrect "S1" and correct "S2" responses for S2 stimuli, 
        % which occur at x > 0
        nI_rS1 = nR_S2(:, 1 : nRatings);
        nC_rS2 = nR_S2(:, nRatings+1 : end);


    case 'discriminate at x'

        % correct "S1" and incorrect "S2" responses for S1 stimuli
        nC_rS1 = nR_S1(:, 1 : nRatings);
        nI_rS2 = nR_S1(:, nRatings+1 : end);
        
        % incorrect "S1" and correct "S2" responses for S2 stimuli
        nI_rS1 = nR_S2(:, 1 : nRatings);
        nC_rS2 = nR_S2(:, nRatings+1 : end);

end

% flip order of rS1 counts so they're listed in order of ascending rating
nC_rS1 = fliplr(nC_rS1);
nI_rS1 = fliplr(nI_rS1);


%% package output

counts.task_type = task_type;

counts.nR_S1 = nR_S1;
counts.nR_S2 = nR_S2;

counts.nC_rS1 = nC_rS1;
counts.nI_rS1 = nI_rS1;
counts.nC_rS2 = nC_rS2;
counts.nI_rS2 = nI_rS2;
