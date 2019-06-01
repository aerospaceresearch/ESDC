function evolution_data = evolver(input, db_data, config)
generation = struct();

generation(1).population = make_population(input, db_data, config);

convergence = 0;
gen_no=2;
while convergence
  [generation(gen_no).population, convergence]= evolve_population(input, db_data, config);
  gen_no=gen_no+1;
end


%disp(generation)
%disp(generation(1).population(1,1).mass_fractions)

evolution_data = generation;


%set relevant parameters from config

% LOOP until convergence is met

  % use input to seed the parameter space
  % use db_data degrees of freedom to go through list of DOF
        %choose random on DOF
          %mutate random within permitted limits + within defined randomized step size
          %scale system according to rule
          %make system consistent
          
          %evaluate new system in comparison to old system
          %select favorable and repeat
          
          %potential convergence -> n times d_improvement < limits
                                     % -> make systematic localized search
                                     
                                     
        % output optimal results and system config
        % output full range of evolutionary history (configurable)
          
          

end

