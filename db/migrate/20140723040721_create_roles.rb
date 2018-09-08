class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.string :description
      t.integer :position, default: 100

      t.timestamps
    end
  end
end
