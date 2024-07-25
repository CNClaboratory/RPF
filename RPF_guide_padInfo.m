% RPF_guide_padInfo
%
% Description of the padInfo struct used in the RPF toolbox. 
%
% padInfo is a struct containing information on the cell padding used to
% prevent numerical issues from arising in SDT analysis. (See
% RPF_guide('info') section on "Fitting d' and meta-d'" for more.) It may
% be present in the info and data structs for SDT-related analyses in which
% cell padding was used. Its contents are described below.
%
% padInfo.padCells
%   - boolean controlling whether response count cells nR_S1 and nR_S2 are 
%     padded to prevent 0s from interfering with the analysis results
%   - identical to info.padCells
%
% padInfo.padCells_correctForTrialCounts
%   - if set to 1, corrects for imbalances in trial counts for S1 and S2 
%     stimuli in determining the padAmount. if S1 and S2 stimuli have different 
%     trial counts, e.g. due to imbalanced rates of stimuls presentation or 
%     due to the task being a 'detect x' task in which the number of S1 trials 
%     at x=0 may differ from the number of S2 trials for each level of x > 0,
%     then using a fixed padAmount can differentially affect S1 and S2
%     stimuli and thereby introduce biases into SDT calculations e.g. of d'. 
% 
%     this correction works by first determining which of nTrialsPerX_S1
%     and nTrialsPerX_S2 is larger, where nTrialsPerX_S1 and nTrialsPerX_S2 
%     are the number of trials per level of stimulus x for S1 and S2 stimuli, 
%     respectively. info.padAmount is used as the padAmount for the
%     stimulus with higher trial count, and the padAmount for the stimulus
%     with the lower trial count is reduced by the ratio of trial counts.
%     
%     for instance, suppose nTrialsPerX_S1 > nTrialsPerX_S2. then
% 
%     padAmount_S1 = info.padAmount
%     padAmount_S2 = info.padAmount * (nTrialsPerX_S2 / nTrialsPerX_S1)
%     
%     such that the padAmount for S2 is lower than that for S1 by the same
%     proportion as the trial counts per level of x are lower for S2 than
%     for S1. this ensures e.g. that if S1 and S2 have imbalanced trial
%     counts, then padding will not bias calculation of d' and meta-d'. for 
%     instance, without this correction, imbalanced trial counts could result 
%     in non-zero values of d' even when the uncorrected HR is equal to the 
%     uncorrected FAR, which should result in d' = 0.
%
%   - identical to info.padCells_correctForTrialCounts'
%
% padInfo.padCells_nonzero_d
%   - boolean controlling whether response count cells nR_S1 and nR_S2 are
%     padded to prevent a value of d' = 0 from interfering with meta-d'
%     analysis (meta-d' is undefined when d' = 0 since fitting meta-d'
%     requires using c' = c/d')
%   - this is done by adding a very small amount (padInfo.padAmount_nonzero_d) 
%     to response counts for correct rejections and hits, i.e. nR_S1(1:nRatings) 
%     and nR_S2(nRatings+1:end), if padInfo.padCells_nonzero_d == 1
%   - identical to info.padCells_nonzero_d
%
% padInfo.nTrialsPerX_S1
%   - the number trials per level of stimulus strength x for S1 stimuli
%   - computed as the number of trials for which a valid response was
%     recorded (as reflected in nR_S1) that is maximal across levels of x,
%     i.e. nTrialsPerX_S1 = max( sum(nR_S1, 2) )
%   - see RPF_guide('counts') for more on nR_S1
%
% padInfo.nTrialsPerX_S2
%   - same as padInfo.nTrialsPerX_S1, but for S2 stimuli
%
% padInfo.padAmount
%   - amount to add to every cell of nR_S1 and nR_S2 if padInfo.padCells == 1 
%     and padInfo.padCells_correctForTrialCounts == 0
%   - identical to info.padAmount
%
% padInfo.padAmount_S1
%   - amount to add to every cell of nR_S1 if padInfo.padCells == 1
%     and padInfo.padCells_correctForTrialCounts == 1
%
% padInfo.padAmount_S2
%   - amount to add to every cell of nR_S2 if padInfo.padCells == 1
%     and padInfo.padCells_correctForTrialCounts == 1
%
% padInfo.padAmount_nonzero_d
%   - amount to add to nR_S1(1:nRatings) and nR_S2(nRatings+1:end) if
%     padInfo.padCells_nonzero_d == 1