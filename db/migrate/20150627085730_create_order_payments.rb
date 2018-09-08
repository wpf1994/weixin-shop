class CreateOrderPayments < ActiveRecord::Migration
  def change
    create_table :order_payments do |t|
      t.references :order, index: true
      t.references :user, index: true
      t.integer :pay_type
      t.float :money
      t.boolean :is_success
      t.datetime :pay_date
      t.timestamps
    end
  end
end
