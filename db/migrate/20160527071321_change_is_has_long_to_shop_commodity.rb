class ChangeIsHasLongToShopCommodity < ActiveRecord::Migration
  def change
    change_column :shop_commodities, :is_has_long, :boolean, default: false
  end
end
