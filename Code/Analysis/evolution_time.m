function evolution_time(t_1, t_2)
%produces evolution time difference in seconds  
t_to_convergence = (t_2-t_1)*60*60*24;
disp(sprintf('Total time for evolver convergence: %d s', t_to_convergence ))
fflush(stdout);
end