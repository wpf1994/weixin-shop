class CreateCommodities < ActiveRecord::Migration
  def change
    create_table :commodities do |t|
      t.string :name
      t.string :summary
      t.string :content
      t.string :identifier
      t.float :reference_price
      t.references :cover, index: true
      t.timestamps
    end
  end
end
