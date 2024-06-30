function SDT = RPF_SDT_analysis(counts)
% SDT = RPF_SDT_analysis(counts)


%% unpack input

nR_S1 = counts.nR_S1;
nR_S2 = counts.nR_S2;

nC     = counts.nC;
nI     = counts.nI;
nC_rS1 = counts.nC_rS1;
nI_rS1 = counts.nI_rS1;
nC_rS2 = counts.nC_rS2;
nI_rS2 = counts.nI_rS2;

nRatings = size(nR_S2,2) / 2;


%% type 1 analysis

% category counts
nCR = sum(nR_S1(:, 1:nRatings ), 2);
nF  = sum(nR_S1(:, nRatings+1:end ), 2);
nM  = sum(nR_S2(:, 1:nRatings), 2);
nH  = sum(nR_S2(:, nRatings+1:end), 2);

% HR and FAR
HR  = nH ./ (nH + nM);
FAR = nF ./ (nF + nCR);
        
% d' and c
d = norminv(HR) - norminv(FAR);
c = -0.5 * (norminv(HR) + norminv(FAR));        


%% detection type 2 analysis

% type 2 category counts by response type
for i_r = 1:nRatings-1
    nH2_rS1(:, i_r)  = sum(nC_rS1(:, i_r+1:end), 2) ./ sum(nC_rS1, 2);
    nM2_rS1(:, i_r)  = sum(nC_rS1(:, 1:i_r), 2) ./ sum(nC_rS1, 2);

    nF2_rS2(:, i_r)  = sum(nI_rS2(:, i_r+1:end), 2) ./ sum(nI_rS2, 2);
    nCR2_rS2(:, i_r) = sum(nI_rS2(:, 1:i_r), 2) ./ sum(nI_rS2, 2);

    nH2_rS2(:, i_r)  = sum(nC_rS2(:, i_r+1:end), 2) ./ sum(nC_rS2, 2);
    nM2_rS2(:, i_r)  = sum(nC_rS2(:, 1:i_r), 2) ./ sum(nC_rS2, 2);

    nF2_rS1(:, i_r)  = sum(nI_rS1(:, i_r+1:end), 2) ./ sum(nI_rS1, 2);
    nCR2_rS1(:, i_r) = sum(nI_rS1(:, 1:i_r), 2) ./ sum(nI_rS1, 2);
end

% overall type 2 category counts
nH2  = nH2_rS1  + nH2_rS2;
nF2  = nF2_rS1  + nF2_rS2;
nM2  = nM2_rS1  + nM2_rS2;
nCR2 = nCR2_rS1 + nCR2_rS2;


% HR2 and FAR2
HR2  = nH2 ./ (nH2 + nM2);
FAR2 = nF2 ./ (nF2 + nCR2);

HR2_rS1  = nH2_rS1 ./ (nH2_rS1 + nM2_rS1);
FAR2_rS1 = nF2_rS1 ./ (nF2_rS1 + nCR2_rS1);

HR2_rS2  = nH2_rS2 ./ (nH2_rS2 + nM2_rS2);
FAR2_rS2 = nF2_rS2 ./ (nF2_rS2 + nCR2_rS2);


%% package output

% type 1
SDT.type1.nR_S1 = counts.nR_S1;
SDT.type1.nR_S2 = counts.nR_S2;

SDT.type1.nH   = nH';
SDT.type1.nF   = nF';
SDT.type1.nM   = nM';
SDT.type1.nCR  = nCR';

SDT.type1.HR   = HR';
SDT.type1.FAR  = FAR';

SDT.type1.d    = d';
SDT.type1.c    = c';


% type 2, all responses
SDT.type2.all.nC = nC;
SDT.type2.all.nI = nI;

SDT.type2.all.nH2  = nH2';
SDT.type2.all.nF2  = nF2';
SDT.type2.all.nM2  = nM2';
SDT.type2.all.nCR2 = nCR2';

SDT.type2.all.HR2  = HR2';
SDT.type2.all.FAR2 = FAR2';


% type 2, "S1" responses
SDT.type2.rS1.nC_rS1 = nC_rS1;
SDT.type2.rS1.nI_rS1 = nI_rS1;

SDT.type2.rS1.nH2_rS1  = nH2_rS1';
SDT.type2.rS1.nF2_rS1  = nF2_rS1';
SDT.type2.rS1.nM2_rS1  = nM2_rS1';
SDT.type2.rS1.nCR2_rS1 = nCR2_rS1';

SDT.type2.rS1.HR2_rS1  = HR2_rS1';
SDT.type2.rS1.FAR2_rS1 = FAR2_rS1';


% type 2, "S2" responses
SDT.type2.rS2.nC_rS2 = nC_rS2;
SDT.type2.rS2.nI_rS2 = nI_rS2;

SDT.type2.rS2.nH2_rS2  = nH2_rS2';
SDT.type2.rS2.nF2_rS2  = nF2_rS2';
SDT.type2.rS2.nM2_rS2  = nM2_rS2';
SDT.type2.rS2.nCR2_rS2 = nCR2_rS2';

SDT.type2.rS2.HR2_rS2  = HR2_rS2';
SDT.type2.rS2.FAR2_rS2 = FAR2_rS2';