function set_default( in_var_name , default_val)
%% set_default(in_var_name, default_val)
%
% Sets “in_var_name” to its default value 
% if it is not both exists nor empty in the “caller” workspace.
% 
%
% in_var_name is a text string that specifies the name of the variable to search for.
% default_val is the default value 
%
% Yoni Halperin, 24-11-2017

cmd_txt = ['exist(''',in_var_name, ''', ''var'');'];
if evalin('caller', cmd_txt)
    cmd_txt = ['~isempty(',in_var_name, ');'];
    if evalin('caller', cmd_txt)
        tf = true;
    else
        tf = false;
    end
else
    tf = false;
end

if ~tf
    assignin('caller', in_var_name, default_val)
end

end

