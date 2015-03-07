class AddInvitationToGuests < ActiveRecord::Migration
  def change
    User.delete_all
    Guest.delete_all

    add_column :guests, :invitation_id, :integer, references: :invitation, null: false
    add_index :guests, :invitation_id
    add_foreign_key :guests, :invitations
  end
end
