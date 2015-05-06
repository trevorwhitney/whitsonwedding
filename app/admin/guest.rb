ActiveAdmin.register Guest do
  permit_params :email, :first_name, :last_name, :rsvp, :attending, :attending_rehearsal
end
