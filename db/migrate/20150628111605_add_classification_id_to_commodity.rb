class AddClassificationIdToCommodity < ActiveRecord::Migration
  def change
    change_table :commodities do |t|
      t.references :classification
    end


  end
end
