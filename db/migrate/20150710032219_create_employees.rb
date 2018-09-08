class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name
      t.string :phone
      t.references :shop, index: true
      t.timestamps
    end
    add_attachment :employees, :photo
  end
end
