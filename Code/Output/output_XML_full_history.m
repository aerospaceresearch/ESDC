function output_XML_full_history(input_struct)
  %XML file generation of the full evolutionary history<
  disp('Writing Full Evolutionary XML Output ');
  fflush(stdout);
  struct2xml(input_struct, 'Output/ESDC_evolution_history');
end