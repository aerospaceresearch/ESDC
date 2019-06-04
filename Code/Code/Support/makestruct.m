function output = makestruct(input, data)
disp('Preparing Output Data')
disp(' ')

output = struct();

for i=1:size(input,2)

    case_name = char(strcat('case',num2str(i)));

    output.(case_name).input = input(i);
    
    %structure calculation data for xml output
    data_fields = fieldnames(data);
    for k=1:size(data_fields ,1)
        if strcmp(data_fields(k),'reference')
           	for j=1:size(fieldnames(data.(char(data_fields(k)))),1)
                analysis_fields = fieldnames(data.(char(data_fields(k))));             
                output.(case_name).analysis.(char(data_fields(k))).(char(analysis_fields(j))) = data.(char(data_fields(k)))(i).(char(analysis_fields(j)));
            end
        else
            for j=1:size(fieldnames(data.(char(data_fields(k)))),1)
                analysis_fields = fieldnames(data.(char(data_fields(k))));             
                output.(case_name).analysis.(char(data_fields(k))).(char(analysis_fields(j))) = data.(char(data_fields(k))).(char(analysis_fields(j)))(i);
            end 
        end
    end

end

disp('Preparing Output Data Complete')
disp(' ')

end
