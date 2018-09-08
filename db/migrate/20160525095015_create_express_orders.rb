class CreateExpressOrders < ActiveRecord::Migration
  def change
    create_table :express_orders do |t|
      t.string :consignee
      t.string :phone
      t.string :address
      t.integer :status
      t.references :shop, index: true
      t.integer :courier_id
      t.text :serial_number
      t.datetime :completed_at

      t.timestamps
    end
  end
end
