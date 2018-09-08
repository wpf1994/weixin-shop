class CreateOrderLogs < ActiveRecord::Migration
  def change
    create_table :order_logs do |t|
      t.references :order, index: true
      t.references :user, index: true
      t.integer :status
      t.text :content
      t.boolean :is_system
      t.timestamps
    end
  end
end
