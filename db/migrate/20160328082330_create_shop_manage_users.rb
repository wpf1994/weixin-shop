class CreateShopManageUsers < ActiveRecord::Migration
  def change
    create_table :shop_manage_users do |t|
      t.string :name
      t.string :phone

      t.timestamps
    end
  end
end
