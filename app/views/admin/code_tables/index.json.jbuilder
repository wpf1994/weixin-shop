json.array!(@admin_code_tables) do |admin_code_table|
  json.extract! admin_code_table, :id, :name, :parent_id, :position, :remark
  json.url admin_code_table_url(admin_code_table, format: :json)
end
