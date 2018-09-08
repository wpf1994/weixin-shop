class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :member_number
      t.string :phone
      t.string :email
      t.float :score, default: 0
      t.string :weixin_id
      t.references :lase_shop, index: true
      t.timestamps
    end
  end
end
