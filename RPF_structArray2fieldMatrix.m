function F_or_R_new = RPF_structArray2fieldMatrix(F_or_R)
% F_or_R_new = RPF_structArray2fieldMatrix(F_or_R)
%
% Given an input F struct or R struct, produces a reformatted version of
% the struct where across-condition data is coded in matrix fields of the 
% data and fit structs rather than being coded in struct arrays, which may 
% make working with the data more convenient in some use cases.
%
% For instance, in the F.data struct, values of the dependent variable P
% are normally coded as F.data(i_cond).P where data is a 1 x nCond struct
% array hold data for each condition, and P is a 1 x nx array holding
% values of P at each level of x for condition i_cond. 
%
% After being reformatted with G = RPF_structArray2fieldMatrix(F), G.data 
% is no longer a struct array but rather a struct. Its field G.data.P is an
% (nCond x nx) matrix where row number indicates condition number i_cond
% and column number indicates level of x. 
%
% Similar considerations hold for other fields of the data and fit structs.
% 
% See RPF_guide('F') and RPF_guide('R') for more on the F and R structs,
% and see RPF_guide('data') and RPF_guide('fit') for more on the data and
% fit structs.

% determine type of input struct
switch F_or_R.info.PF_type
    case 'R(P1)'
        F_or_R_new = reformatR(F_or_R);
    case 'F(x)'
        F_or_R_new = reformatF(F_or_R);
end

end


%% reformat F struct

function F_new = reformatF(F)

F_new.info = F.info;

% reformat data struct array into a single struct with matrix fields
data_fields = fields(F.data);
for i_field = 1:length(data_fields)

    if ischar(eval(['F.data(1).' data_fields{i_field}]))
        f = eval(['{F.data.' data_fields{i_field} '};']);
    
%     elseif size(eval(['F.data(1).' data_fields{i_field}]), 1) > 1 && size(eval(['F.data(1).' data_fields{i_field}]), 2) > 1
    elseif size(eval(['F.data(1).' data_fields{i_field}]), 1) > 1
        f = eval(['[F.data.' data_fields{i_field} '];']);
        f = reshape(f, [size(f,1), size(f,2)/F_new.info.nCond, F_new.info.nCond]);
        
    else
        f = eval(['[F.data.' data_fields{i_field} '];']);
        f = reshape(f, [length(f) / F_new.info.nCond, F_new.info.nCond])';
    end

    eval(['F_new.data.' data_fields{i_field} ' = f;']);
end

% reformat fit struct array into a single struct with matrix fields
fit_fields = fields(F.fit);
for i_field = 1:length(fit_fields)

    % handle cond_label, PF, and xt_fn fields
    if strcmp(fit_fields{i_field}, 'cond_label') || strcmp(fit_fields{i_field}, 'PF') || ...
       strcmp(fit_fields{i_field}, 'xt_fn') || strcmp(fit_fields{i_field}, 'xt_fn_inv')
        f = eval(['{F.fit.' fit_fields{i_field} '};']);
        eval(['F_new.fit.' fit_fields{i_field} ' = f;']);
      
    % handle constrain field
    elseif strcmp(fit_fields{i_field}, 'constrain')

        if isfield(F.fit(1).constrain, 'value')
            constr_fields = fields(F.fit(1).constrain.value);
            for i_field2 = 1:length(constr_fields)
                for i_cond = 1:F.info.nCond
                    eval(['F_new.fit.constrain.value.' constr_fields{i_field2} '(i_cond,1) = F.fit(i_cond).constrain.value.' constr_fields{i_field2} ';'])
                end
            end
        end

        if isfield(F.fit(1).constrain, 'acrossCond')
            constr_fields = fields(F.fit(1).constrain.acrossCond);
            for i_field2 = 1:length(constr_fields)
                for i_cond = 1:F.info.nCond
                    eval(['F_new.fit.constrain.acrossCond.' constr_fields{i_field2} '(i_cond,1) = F.fit(i_cond).constrain.acrossCond.' constr_fields{i_field2} ';'])
                end
            end
        end            

    % handle meta_t2c fields
    elseif strcmp(fit_fields{i_field}, 'meta_t2c_unadj') || strcmp(fit_fields{i_field}, 'meta_t2c')
        f = eval(['[F.fit.' fit_fields{i_field} '];']);
        f = reshape(f, [size(f,1), size(f,2) / F_new.info.nCond, F_new.info.nCond]);
        eval(['F_new.fit.' fit_fields{i_field} ' = f;']);
        
    % handle all other fields
    else
        f = eval(['[F.fit.' fit_fields{i_field} '];']);
        f = reshape(f, [length(f) / F_new.info.nCond, F_new.info.nCond])';
        eval(['F_new.fit.' fit_fields{i_field} ' = f;']);
    end

end

end


%% reformat R struct

function R_new = reformatR(R)

% info is just copied over
R_new.info = R.info;

% reformat F1 and F2 fields
R_new.F1 = reformatF(R.F1);
R_new.F2 = reformatF(R.F2);

fit_fields = fields(R.fit);
for i_field = 1:length(fit_fields)

    % handle PF field
    if strcmp(fit_fields{i_field}, 'PF')
        f = eval(['{R.fit.' fit_fields{i_field} '};']);
        eval(['R_new.fit.' fit_fields{i_field} ' = f;']);

    % handle params field
    elseif strcmp(fit_fields{i_field}, 'params')

        if isfield(R.info, 'PF') && isa(R.info.PF, 'function_handle') && strcmp('RPF_interp_RPF', func2str(R.info.PF))
            for i_cond = 1:R.info.nCond
                eval(['R_new.fit.params.P1_sorted_unique{i_cond} = R.fit(i_cond).params.P1_sorted_unique;'])
                eval(['R_new.fit.params.P2_sorted_unique{i_cond} = R.fit(i_cond).params.P2_sorted_unique;'])
                eval(['R_new.fit.params.interp_method{i_cond}    = R.fit(i_cond).params.interp_method;'])
            end
        else
            for i_cond = 1:R.info.nCond
                eval(['R_new.fit.params.F1(i_cond,:) = R.fit(i_cond).params.F1;'])
                eval(['R_new.fit.params.F2(i_cond,:) = R.fit(i_cond).params.F2;'])
            end
        end
        
    % handle all other fields
    else
        f = eval(['[R.fit.' fit_fields{i_field} '];']);
        f = reshape(f, [length(f) / R_new.info.nCond, R_new.info.nCond])';
        eval(['R_new.fit.' fit_fields{i_field} ' = f;']);
    end
end

end