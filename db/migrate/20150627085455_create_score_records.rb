class CreateScoreRecords < ActiveRecord::Migration
  def change
    create_table :score_records do |t|
      t.references :customer, index: true
      t.boolean :is_plus
      t.integer :relation_id
      t.string :relation_id_type
      t.string :reason
      t.timestamps
    end
  end
end
