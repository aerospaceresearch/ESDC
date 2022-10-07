%Function to evaluate the performance time of the evolutionary solver
%TODOs: Add auxiliary evaluation, e.g. time per lineage, time per generation. n_seeds etc
function evolution_time(t_0)                                                    % t_0 is the reference time to be considered
t_1=now;                                                                        % Reference timer for performance evaluation: After input processing
t_to_convergence = (t_1-t_0)*60*60*24;                                          % Produces evolution time difference in seconds  
disp(sprintf('Total time for evolver convergence: %d s', t_to_convergence ));   % CLI output of total time
fflush(stdout);                                                                 % Forces CLI output
end