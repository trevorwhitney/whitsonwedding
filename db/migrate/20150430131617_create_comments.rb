class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :body
      t.references :user
    end
    add_foreign_key :comments, :users
  end
end
