function appendToLogFileDCEP(data, restart,runID)

    folderPath = strcat('Output/',num2str(runID));

    if ~(exist(folderPath, 'dir') == 7) %The return value of exist is compared to 7, which indicates that the path exists and corresponds to a directory.
      mkdir(folderPath)
    end
    % check if folder for runID exists, if not create
%    disp(folderPath)
    logFileName = fullfile(folderPath, 'ESDC_tool.log');
%    disp(logFileName)

    if restart || ~exist(logFileName, 'file')
        fileID = fopen(logFileName, 'w');
    else
        fileID = fopen(logFileName, 'a');
    end

    fprintf(fileID, '%s\n', data);
    fclose(fileID);
end

