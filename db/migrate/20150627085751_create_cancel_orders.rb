class CreateCancelOrders < ActiveRecord::Migration
  def change
    create_table :cancel_orders do |t|
      t.references :order, index: true
      t.references :shop, index: true
      t.references :user, index: true
      t.float :total_amount
      t.string :receipt
      t.timestamps
    end
  end
end
