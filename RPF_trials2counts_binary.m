function [nPos, nTot] = RPF_trials2counts_binary(x, y, x_vals)
% [nPos, nTot] = RPF_trials2counts_binary(x, y, x_vals)

for i_x = 1:length(x_vals)
    f         = ( x == x_vals(i_x) );
    nPos(i_x) = sum( y(f) == 1 );
    nTot(i_x) = sum( y(f) == 1 | y(f) == 0 );
end