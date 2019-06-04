function [new_val] = mutator_default(old_val, max_val, min_val, evolver_config)

  %derive minimal step size from min, max range and evolver config definition
  dx_min = (max_val-min_val)*evolver_config.minimal_step_size;
  
  %random decide for increase or decrease
  direction = (-1)^randi(2);
  %use incremental changes of more than 1 to allow to jump non-optimal gaps
  jump = randi(evolver_config.max_jump_range);
  
  %new value is an incremental change from previous
  new_val = old_val+direction*dx_min*jump;
  
  %check for max boundary
  if new_val > max_val
    new_val = max_val;
  end
  
  %check for min boundary
  if new_val < min_val
    new_val = min_val;
  end
end