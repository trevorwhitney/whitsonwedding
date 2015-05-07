ActiveAdmin.register Guest do
  permit_params :email, :first_name, :last_name, :rsvp, :attending, :attending_rehearsal, :invitation_id
  form do |f|
    f.inputs do
      f.input :invitation_id, :label => 'Invitation', :as => :select, :collection => Invitation.all.map {|i| ["#{i.id}: #{i.email_key}", i.id]}
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :rsvp
      f.input :attending
      f.input :attending_rehearsal
    end
    actions
  end
end
