# module BaseDataHandleModule
#   include NestedDataModule
#
#   #加载机构的通讯录分组
#   def nested_contacts_groups_by_organization_id(organization_id)
#     nested_set_options(ContactsGroup.where(organization_id: organization_id)) {|i| "#{'-' * i.level} #{i.name}" }
#   end
#
#   #加载所有码表，如果code不为空则只加载不包括code在内的
#   def load_code_table(invert = true, code = nil)
#     if code.nil?
#       @base_code_tables = nested_set_options(CodeTable) {|i| "#{'-' * i.level} #{i.name}" }
#       @base_code_tables_invert = custom_invert @base_code_tables, '-' if invert
#     else
#       variable = nested_set_options_ts([CodeTable.where(code: code).first], nil, true, false) {|i| "#{'-' * (code.nil? ? i.level : (i.level - 1))} #{i.name}" }
#       if invert
#         variable_invert = custom_invert variable, '-'
#         return variable, variable_invert
#       else
#         return variable
#       end
#     end
#   end
#
#   def present_and_sort(array)
#     array.select!{|org| org.deleted_at.blank?}.sort!{ |a,b| a.position <=> b.position }
#     array
#   end
#
#   private
#   #[['name', 'id']] => {'id': 'name'}
#   #rep 要去除的符号
#   def custom_invert(array, rep = nil)
#     Hash[*array.map{ |p| [p[1], (rep.nil? ? p[0] : p[0].gsub(rep, ''))] }.flatten]
#   end
# end