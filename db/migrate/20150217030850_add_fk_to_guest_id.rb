class AddFkToGuestId < ActiveRecord::Migration
  def change
    change_column :users, :guest_id, :integer, null: false
    add_foreign_key :users, :guests
  end
end
