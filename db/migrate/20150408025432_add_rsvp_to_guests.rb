class AddRsvpToGuests < ActiveRecord::Migration
  def change
    add_column :guests, :rsvp, :boolean, null: false, default: false
  end
end
