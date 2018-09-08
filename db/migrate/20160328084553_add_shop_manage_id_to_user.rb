class AddShopManageIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :shop_manage_id, :integer
  end
end
