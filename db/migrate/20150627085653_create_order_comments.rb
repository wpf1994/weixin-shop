class CreateOrderComments < ActiveRecord::Migration
  def change
    create_table :order_comments do |t|
      t.references :order, index: true
      t.references :shop, index: true
      t.float :total_star
      t.float :speed_star
      t.float :serve_start
      t.text :content
      t.timestamps
    end
  end
end
