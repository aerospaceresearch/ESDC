function output_XML_full_history(input_struct,runID)
  %XML file generation of the full evolutionary history<
  disp('Writing Full Evolutionary XML Output ');
  fflush(stdout);

  folderPath = strcat('Output/',num2str(runID));
  xml_FileName = fullfile(folderPath, 'ESDC_evolution_history');


  struct2xml(input_struct, xml_FileName);
end
