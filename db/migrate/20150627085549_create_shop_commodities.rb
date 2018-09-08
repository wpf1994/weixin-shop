class CreateShopCommodities < ActiveRecord::Migration
  def change
    create_table :shop_commodities do |t|
      t.references :shop, index: true
      t.references :commodity, index: true
      t.float :price
      t.integer :position, default: 100
      t.boolean :enable, default: true
      t.integer :sales_volume, default: 0
      t.date :delete_at
      t.timestamps
    end
  end
end
