function evolution_data = evolver(input, db_data, config)
generation_0 = struct();

generation_0 = makeInitialPopulation(input, db_data, config);


disp(generation_0)
disp(generation_0(1,1))
disp(generation_0(1,1).subsystem_masses)

evolution_data = generation_0


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

