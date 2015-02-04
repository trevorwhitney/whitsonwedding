class Guest < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
    end
  end
end
