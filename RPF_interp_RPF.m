function P2 = RPF_interp_RPF(R, P1)
% P2 = RPF_interp_RPF(R, P1)

for i_cond = 1:R.info.nCond

    if ~strcmp('isotonic',R.fit(i_cond).params.interp_method)

        P2(i_cond,:) = interp1(R.fit(i_cond).params.P1_sorted_unique, ...
                               R.fit(i_cond).params.P2_sorted_unique, ...
                               P1, ...
                               R.fit(i_cond).params.interp_method);

    else

        % Use isotonic regression for the RPF, then force the final RPF interpolation step to be linear.
        y_isotonic = RPF_interp_isotonic(R.fit(i_cond).params.P1_sorted_unique,R.fit(i_cond).params.P2_sorted_unique);
        P2(i_cond,:) =  interp1(R.fit(i_cond).params.P1_sorted_unique, ...
                               y_isotonic, ...
                               P1, ...
                               'linear');

    end

end
