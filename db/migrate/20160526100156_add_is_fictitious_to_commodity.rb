class AddIsFictitiousToCommodity < ActiveRecord::Migration
  def change
    add_column :commodities, :is_fictitious, :boolean,default: false
    add_column :commodities, :show_content, :boolean, default: false
  end
end
