class CreateClassifications < ActiveRecord::Migration
  def change
    create_table :classifications do |t|
      t.string :name
      t.references :parent, index: true
      t.integer :position, default: 100
      t.timestamps
    end
  end
end
