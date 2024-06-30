function P = RPF_meanRating_PF(params, xt)

% get p(high rating) PF for each level of rating threshold
for i = 1:size(params.value, 1)    
    P(i,:) = params.PF( params.value(i, :), xt );
end

% sum across p(high rating) PFs and add 1 to get mean rating PF
P = 1 + sum(P, 1);