types = {CodeTable: 'ct', Permission: 'permission'}
json.array!(@tree_data) do |data|
    json.model_id data.id
    json.type types[data.class.to_s.to_sym]
    if data.class == CodeTable
        json.name data.name
        json.isParent true
        json.id "ct_#{data.id}"
    elsif data.class == Permission
        json.name data.description
        json.id "ct_#{data.group_id}_permission_#{data.id}"
        json.pId "ct_#{data.group_id}"
        if @selected.present? && @selected.include?(data)
            json.checked true
        end
    end
end
