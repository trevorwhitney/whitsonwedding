class AddGuestIdToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :guest, index: true
  end
end
