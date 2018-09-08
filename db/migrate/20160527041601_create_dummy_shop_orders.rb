class CreateDummyShopOrders < ActiveRecord::Migration
  def change
    create_table :dummy_shop_orders do |t|
      t.references :order, index: true
      t.string :user_name
      t.string :user_phone
      t.string :commodity_name
      t.string :commodity_num
      t.boolean :is_fund, default: false

      t.timestamps
    end
  end
end
