function [in_struct] = typeset_struct(in_struct)
 % Author: M. Ehresmann 2019
 % Check XML2Struct product and convert all "Text" fields to appropriate numbers and strings.
 % Look ahead two field layers. If second layer is text convert and append previous struct.
  if isstruct(in_struct)                  %check if directly struct
    %disp("struct case");
    fields_1 =fieldnames(in_struct);
    
    for i=1: size(fields_1,1)
      %disp(fields_1)
      if isstruct(in_struct.(fields_1{i}))    %struct upon struct allows text
         %disp("struct *2 case");
        fields_2 =fieldnames(in_struct.(fields_1{i}));
        
        %disp(fields_2)
        if strcmp(fields_2{1},"Text")
          [num, state] = str2num(in_struct.(fields_1{i}).Text);
          if state == 0
            %disp('string');
            field_value = char(in_struct.(fields_1{i}).Text);
          else
            %disp('scalar');
            field_value = num;
          end
          in_struct.(fields_1{i})  = field_value;     %redefine previous substructure with field "text" to field with generated value
          
        elseif strcmp(fields_2{1},"Attributes") || strcmp(fields_1{i},"Attributes") 
##        elseif strcmp(fields_2{1},"version") ||strcmp(fields_2{1},"show") ||strcmp(fields_2{1},"dcep_show") || strcmp(fields_2{1},"dcep_version") || strcmp(fields_2{1},"dcep_description") || strcmp(fields_2{1},"dcep_name") || strcmp(fields_2{1},"dcep_unit")  || strcmp(fields_2{1},"description") 

        else                                 % if struct upon struct is not text decend deeper
          in_struct.(fields_1{i}) = typeset_struct(in_struct.(fields_1{i})); 
        end
     
      else                                  %if type is cell descent deeper in cell array
        %disp("cell case")
        for j=1:size(in_struct.(fields_1{i}),2)
        fields_2 =fieldnames(in_struct.(fields_1{i}){1,j});
        if (strcmp(fields_2{1},"Text"))
           [num, state] = str2num(in_struct.(fields_1{i}){1,j}.Text);
          if state ==0
            %disp('string');
            field_value = char(in_struct.(fields_1{i}){1,j}.Text);
          else
            %disp('scalar');
            field_value = num;
          end
          in_struct.(fields_1{i}){1,j}  = field_value;     %redefine previous substructure with field "text" to field with generated value
        else
         % if isstruct(in_struct.(fields_1{i}))
          in_struct.(fields_1{i}){1,j}=typeset_struct(in_struct.(fields_1{i}){1,j});
        end

        end
          
      end
    end  
  end
  

end

% MIT License
% Copyright (c) 2019 Manfred Ehresmann
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.