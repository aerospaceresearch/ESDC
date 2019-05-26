function [num] = num_struct_members_full(in_struct,field)
%recursion function to find the number of members in a input structure with cell array fields
num =0;
names = fieldnames(in_struct);

for i=1:numel(names)
  if strcmp(names{i},field) == 1
    n=size(in_struct.(names{i}),2);   % determine struct array size , might not work for other types of structs
    num= num + n;
  else
    num = num + num_struct_members_full(in_struct.(names{i}),field);
  end
end
    
end