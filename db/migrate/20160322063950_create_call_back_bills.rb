class CreateCallBackBills < ActiveRecord::Migration
  def change
    create_table :call_back_bills do |t|
      t.references :order, index: true
      t.float :cash_fee
      t.string :out_trade_no
      t.string :transaction_id
      t.references :order_place_in, index: true
      t.text :remark

      t.timestamps
    end
  end
end
