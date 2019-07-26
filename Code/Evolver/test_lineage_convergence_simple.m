function convergence = test_lineage_convergence_simple(new_data, lineage_data, config)
  n_no_success= config.Simulation_parameters.evolver.n_fails_to_converge;

  if ((numel(lineage_data)<n_no_success))
    %disp('Generation number too low for convergence.')
    convergence=0;
  elseif new_data.evolution_success
    convergence=0;
   % disp('Current success.')
  else
   % disp('Potential convergence.')
      for j=1:n_no_success
          if lineage_data{end-j}.evolution_success
            convergence=0;
          %  disp('Recent success.')
            break;
          else
            convergence =1;
           % disp('Convergance of lineage.')
          end
      end
  end
end