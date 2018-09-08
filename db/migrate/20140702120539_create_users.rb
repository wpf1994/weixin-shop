class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :phone, unique: true
      t.string :remark
      t.references :organization, index: true

      t.timestamps
    end
  end
end
