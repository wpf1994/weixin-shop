class AddMaterialCommodityAmountToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :material_commodity_amount, :float, default: 0
    add_column :orders, :fictitious_commodity_amount, :float, default: 0
  end
end
