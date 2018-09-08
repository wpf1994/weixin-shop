class AddExtendInfoToShopCommodity < ActiveRecord::Migration
  def change
    add_column :shop_commodities, :left_count, :integer, default: 0
    add_column :shop_commodities, :is_has_long, :boolean, default: true
  end
end
