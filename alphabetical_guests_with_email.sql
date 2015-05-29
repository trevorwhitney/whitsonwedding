select first_name, last_name, trim(lower(email)) 
  from guests 
  where trim(email) is not null 
    and trim(email) != ''
  order by last_name;
