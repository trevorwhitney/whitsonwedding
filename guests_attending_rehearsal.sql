select first_name, last_name, trim(lower(email)) 
  from guests 
  where rsvp = true
    and attending_rehearsal = true
  order by last_name;
