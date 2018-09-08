class CreateOrderPlaceIns < ActiveRecord::Migration
  def change
    create_table :order_place_ins do |t|
      t.references :order
      t.string :out_trade_no, index: true
      t.float :cash_fee
      t.integer :status
      t.text :remark
      t.timestamps
    end
  end
end
