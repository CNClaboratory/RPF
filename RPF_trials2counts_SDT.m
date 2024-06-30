function [counts, padInfo] = RPF_trials2counts_SDT(trialData, info)
% [counts, padInfo] = RPF_trials2counts_SDT(trialData, info)


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


%% handle response padding

% determine padInfo
padInfo.padCells  = info.padCells;
padInfo.padAmount = info.padAmount;

nTrialsPerX = max( [sum(nR_S1, 2)', sum(nR_S2, 2)'] );
padInfo.nTrialsPerX = nTrialsPerX;

% tally max HR, min FAR, and max d' allowed by padding and trial counts
HR_pad_max  = (nTrialsPerX + info.padAmount*nRatings) / (nTrialsPerX + 2*info.padAmount*nRatings);
FAR_pad_min = info.padAmount*nRatings / (nTrialsPerX + 2*info.padAmount*nRatings);

padInfo.HR_pad_max  = HR_pad_max;
padInfo.FAR_pad_min = FAR_pad_min;
padInfo.d_pad_max   = norminv( HR_pad_max ) - norminv( FAR_pad_min );

% optinally apply padding to prevent zeros in nR_S1 and nR_S2, 
% since this interferes with estimation of d' and meta-d'
if info.padCells
    nR_S1 = nR_S1 + info.padAmount;
    nR_S2 = nR_S2 + info.padAmount;
end

% optionally apply padding to prevent d' = 0, 
% since meta-d' is undefined when d' = 0
if info.padCells_nonzero_d
    nR_S1(:, 1 : nRatings)     = nR_S1(:, 1 : nRatings)     + info.padAmount_nonzero_d;
    nR_S2(:, nRatings+1 : end) = nR_S2(:, nRatings+1 : end) + info.padAmount_nonzero_d;
end


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

nC = nC_rS1 + nC_rS2;
nI = nI_rS1 + nI_rS2;


%% package output

counts.task_type = task_type;

counts.nR_S1 = nR_S1;
counts.nR_S2 = nR_S2;

counts.nC     = nC;
counts.nI     = nI;
counts.nC_rS1 = nC_rS1;
counts.nI_rS1 = nI_rS1;
counts.nC_rS2 = nC_rS2;
counts.nI_rS2 = nI_rS2;
