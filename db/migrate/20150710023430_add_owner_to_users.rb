class AddOwnerToUsers < ActiveRecord::Migration
  def change
    change_table :users do |c|
      c.integer :owner_id
      c.string :owner_type
    end
  end
end
