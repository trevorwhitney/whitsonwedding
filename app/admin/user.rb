ActiveAdmin.register User do
  permit_params :email, :is_admin
end
