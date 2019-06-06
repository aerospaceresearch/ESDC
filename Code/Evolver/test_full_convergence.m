function [convergence n_converged] = test_full_convergence(population_data)
%test the full convergence state of a current population

convergence_array = zeros(size(population_data,1),size(population_data,2));
 for i=1:size(population_data,1)
    for j=1:size(population_data,2)
      convergence_array(i,j) = population_data(i,j).convergence;
    end
  end
 
  if all(convergence_array)
     convergence = 1;
  else
     convergence = 0;
  end
  n_converged = sum(sum(convergence_array));
end