class AddSingleStatisticsToClassification < ActiveRecord::Migration
  def change
    add_column :classifications, :single_statistics, :boolean
  end
end
