class CreateOrderExpresses < ActiveRecord::Migration
  def change
    create_table :order_expresses do |t|
      t.references :order, index: true
      t.string :address
      t.string :phone
      t.string :name
      t.references :user, index: true
      t.boolean :is_express_now, default: true
      t.datetime :express_start_time
      t.datetime :express_end_time
      t.datetime :complete_date
      t.boolean :is_ontime
      t.timestamps
    end
  end
end
