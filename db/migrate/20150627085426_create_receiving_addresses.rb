class CreateReceivingAddresses < ActiveRecord::Migration
  def change
    create_table :receiving_addresses do |t|
      t.references :customer, index: true
      t.string :address
      t.string :phone
      t.string :name
      t.boolean :is_default
      t.references :community, index: true
      t.timestamps
    end
  end
end
