class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.integer :user_id
      t.string :ip_address
      t.string :access_token
    end
  end
end
