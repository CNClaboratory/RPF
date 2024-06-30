function paramsFree = RPF_get_paramsFree(constrain)
% paramsFree = RPF_get_paramsFree(constrain)

paramsFree = [1 1 1 1];

if isstruct(constrain) && isfield(constrain, 'value')
    if isfield(constrain.value, 'alpha') && ~isempty(constrain.value.alpha)
        paramsFree(1) = 0;
    end

    if isfield(constrain.value, 'beta') && ~isempty(constrain.value.beta)
        paramsFree(2) = 0;
    end    

    if isfield(constrain.value, 'gamma') && ~isempty(constrain.value.gamma)
        paramsFree(3) = 0;
    end        

    if isfield(constrain.value, 'lambda') && ~isempty(constrain.value.lambda)
        paramsFree(4) = 0;
    end
    
    % handle possibility that these are params for scaled PF
    if isfield(constrain.value, 'omega') && ~isempty(constrain.value.omega)
        paramsFree(4) = 0;
    end        
end