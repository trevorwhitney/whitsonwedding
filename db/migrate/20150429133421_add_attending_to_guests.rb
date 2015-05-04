class AddAttendingToGuests < ActiveRecord::Migration
  def change
    change_table :guests do |t|
      t.boolean :attending, null: false, default: false
      t.boolean :attending_rehearsal, null: false, default: false
      t.timestamp :updated_at
    end
  end
end
