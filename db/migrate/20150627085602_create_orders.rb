class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :customer, index: true
      t.references :shop, index: true
      t.datetime :payed_at
      t.float :total_amount, default: 0
      t.float :commodity_amount, default: 0
      t.float :consume_score, default: 0
      t.float :consume_amount, default: 0
      t.float :actual_amount, default: 0
      t.string :actual_reason
      t.integer :status
      t.datetime :complete_date
      t.datetime :set_out_at
      t.timestamps
    end
  end
end
