json.array!(@tree_data) do |data|
    json.model_id data.id
    json.type 'role'
    json.name data.name
    json.title data.description
    json.id data.id
    json.isParent false
    if @selected.present? && @selected.include?(data)
        json.checked true
    end
end
