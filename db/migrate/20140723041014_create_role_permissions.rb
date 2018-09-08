class CreateRolePermissions < ActiveRecord::Migration
  def change
    create_table :role_permissions do |t|
      t.references :role, index: true
      t.references :permission, index: true

      t.timestamps
    end
  end
end
