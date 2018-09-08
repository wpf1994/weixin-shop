class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :map_location
      t.references :region, index: true
      t.references :parent, index: true
      t.boolean :can_express, default: true
      t.float :express_amount, default: 0
      t.time :can_express_start_date, default: '00:00:00'
      t.time :can_express_end_date, default: '23:59:59'
      t.timestamps
    end
  end
end
