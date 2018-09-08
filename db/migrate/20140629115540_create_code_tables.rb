class CreateCodeTables < ActiveRecord::Migration
  def change
    create_table :code_tables do |t|
      t.string :name
      t.references :parent, index: true
      t.integer :position, default: 100
      t.text :remark
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.string :default_value

      t.timestamps
    end
  end
end
