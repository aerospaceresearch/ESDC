function [ s ] = xml2struct( file )
%Convert xml file into a MATLAB structure
% [ s ] = xml2struct( file )
%
% A file containing:
% <XMLname attrib1="Some value">
%   <Element>Some text</Element>
%   <DifferentElement attrib2="2">Some more text</Element>
%   <DifferentElement attrib3="2" attrib4="1">Even more text</DifferentElement>
% </XMLname>
%
% Will produce:
% s.XMLname.Attributes.attrib1 = "Some value";
% s.XMLname.Element.Text = "Some text";
% s.XMLname.DifferentElement{1}.Attributes.attrib2 = "2";
% s.XMLname.DifferentElement{1}.Text = "Some more text";
% s.XMLname.DifferentElement{2}.Attributes.attrib3 = "2";
% s.XMLname.DifferentElement{2}.Attributes.attrib4 = "1";
% s.XMLname.DifferentElement{2}.Text = "Even more text";
%
% Please note that the following characters are substituted
% '-' by '_dash_', ':' by '_colon_' and '.' by '_dot_'
%
% Written by W. Falkena, ASTI, TUDelft, 21-08-2010
% Attribute parsing speed increased by 40% by A. Wanner, 14-6-2011
% Added CDATA support by I. Smirnov, 20-3-2012
%
% Modified by X. Mo, University of Wisconsin, 12-5-2012

% Modified by M. Ehresmann, University of Stuttgart, 18-03-2019, to work on Octave with Java xerces 2.12.0.

    if (nargin < 1)
        clc;
        help xml2struct
        return
    end
    
    if isa(file, 'org.apache.xerces.dom.DeferredDocumentImpl') || isa(file, 'org.apache.xerces.dom.DeferredElementImpl')
        % input is a java xml object
        xDoc = file;
    else
        %check for existance
        if (exist(file,'file') == 0)
            %Perhaps the xml extension was omitted from the file name. Add the
            %extension and try again.
            if (isempty(strfind(file,'.xml')))
                file = [file '.xml'];
            end
            
            if (exist(file,'file') == 0)
                error(['The file ' file ' could not be found']);
            end
        end
        %read the xml file
        xDoc = xmlread(file);
    end
    
    %parse xDoc into a MATLAB structure
    s = parseChildNodes(xDoc);
    
end

% ----- Subfunction parseChildNodes -----
function [children,ptext,textflag] = parseChildNodes(theNode)
    % Recurse over node children.
    children = struct;
    ptext = struct; textflag = 'Text';
    if theNode.hasChildNodes()
        childNodes = theNode.getChildNodes();
        numChildNodes = theNode.getLength();

        for count = 1:numChildNodes
            theChild = childNodes.item(count-1);
            [text,name,attr,childs,textflag] = getNodeData(theChild);
            
            if (~strcmp(name,'#text') && ~strcmp(name,'#comment') && ~strcmp(name,'#cdata_dash_section'))
                %XML allows the same elements to be defined multiple times,
                %put each in a different cell
                if (isfield(children,name))
                    if (~iscell(children.(name)))
                        %put existsing element into cell format
                        children.(name) = {children.(name)};
                    end
                    index = length(children.(name))+1;
                    %add new element
                    children.(name){index} = childs;
                    if(~isempty(fieldnames(text)))
                        children.(name){index} = text; 
                    end
                    if(~isempty(attr)) 
                        children.(name){index}.('Attributes') = attr; 
                    end
                else
                    %add previously unknown (new) element to the structure
                    children.(name) = childs;
                    if(~isempty(text) && ~isempty(fieldnames(text)))
                        children.(name) = text; 
                    end
                    if(~isempty(attr)) 
                        children.(name).('Attributes') = attr; 
                    end
                end
            else
                ptextflag = 'Text';
                if (strcmp(name, '#cdata_dash_section'))
                    ptextflag = 'CDATA';
                elseif (strcmp(name, '#comment'))
                    ptextflag = 'Comment';
                end
                
                %this is the text in an element (i.e., the parentNode) 
                if (~isempty(regexprep(text.(textflag),'[\s]*','')))
                    if (~isfield(ptext,ptextflag) || isempty(ptext.(ptextflag)))
                        ptext.(ptextflag) = text.(textflag);
                    else
                        %what to do when element data is as follows:
                        %<element>Text <!--Comment--> More text</element>
                        
                        %put the text in different cells:
                        % if (~iscell(ptext)) ptext = {ptext}; end
                        % ptext{length(ptext)+1} = text;
                        
                        %just append the text
                        ptext.(ptextflag) = [ptext.(ptextflag) text.(textflag)];
                    end
                end
            end
            
        end
    end
end

% ----- Subfunction getNodeData -----
function [text,name,attr,childs,textflag] = getNodeData(theNode)
    % Create structure of node info.
    
    %make sure name is allowed as structure name
    name = char(theNode.getNodeName());
    name = strrep(name, '-', '_dash_');
    name = strrep(name, ':', '_colon_');
    name = strrep(name, '.', '_dot_');

    attr = parseAttributes(theNode);
    if (isempty(fieldnames(attr))) 
        attr = []; 
    end
    
    %parse child nodes
    [childs,text,textflag] = parseChildNodes(theNode);
    
    if (isempty(fieldnames(childs)) && isempty(fieldnames(text)))
        %get the data of any childless nodes
        % faster than if any(strcmp(methods(theNode), 'getData'))
        % no need to try-catch (?)
        % faster than text = char(getData(theNode));
        text.(textflag) = char(theNode.getTextContent());
    end
    
end

% ----- Subfunction parseAttributes -----
function attributes = parseAttributes(theNode)
    % Create attributes structure.

    attributes = struct;
    if theNode.hasAttributes()
       theAttributes = theNode.getAttributes();
       numAttributes = theAttributes.getLength();

       for count = 1:numAttributes
            %attrib = item(theAttributes,count-1);
            %attr_name = regexprep(char(getName(attrib)),'[-:.]','_');
            %attributes.(attr_name) = char(getValue(attrib));
            %Suggestion of Adrian Wanner
            str = char(theAttributes.item(count-1)); %Modified here by M. Ehresmann
            k = strfind(str,'='); 
            attr_name = str(1:(k(1)-1));
            attr_name = strrep(attr_name, '-', '_dash_');
            attr_name = strrep(attr_name, ':', '_colon_');
            attr_name = strrep(attr_name, '.', '_dot_');
            attributes.(attr_name) = str((k(1)+2):(end-1));
       end
    end
end

%Copyright (c) 2010, Wouter Falkena
%All rights reserved.

%Redistribution and use in source and binary forms, with or without
%modification, are permitted provided that the following conditions are
%met:
%
%    * Redistributions of source code must retain the above copyright
%      notice, this list of conditions and the following disclaimer.
%    * Redistributions in binary form must reproduce the above copyright
%      notice, this list of conditions and the following disclaimer in
%      the documentation and/or other materials provided with the distribution

%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
%AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
%IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
%ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
%LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
%CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
%SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
%INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
%CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
%ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
%POSSIBILITY OF SUCH DAMAGE.

function [in_struct] = typeset_struct(in_struct)
 % Author: M. Ehresmann 2019
 % Check XML2Struct product and convert all "Text" fields to appropriate numbers and strings.
 % Look ahead two field layers. If second layer is text convert and append previous struct.
  if isstruct(in_struct)                  %check if directly struct
    %disp("struct case");
    fields_1 =fieldnames(in_struct);
    
    for i=1: size(fields_1,1)
      if isstruct(in_struct.(fields_1{i}))    %struct upon strFuct allows text
         %disp("struct *2 case");
        fields_2 =fieldnames(in_struct.(fields_1{i}));
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
         % disp("here stuff for Attributes")
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
