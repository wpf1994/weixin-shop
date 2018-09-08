class CreateOrderDetails < ActiveRecord::Migration
  def change
    create_table :order_details do |t|
      t.references :order, index: true
      t.references :shop_commodity, index: true
      t.references :commodity, index: true
      t.float :price
      t.integer :count
      t.float :total_amount
      t.timestamps
    end
  end
end
