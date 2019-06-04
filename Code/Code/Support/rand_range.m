function randval = rand_range(min_val, max_val )
  %returns random value between range minimum and range maximum
randval = min_val+rand*(max_val-min_val);  
end