# # coding: UTF-8
# # encoding: UTF-8
# require "string/utf8"
# module PhoneToolModule
#   #将上传的文件转换成号码
#   #提交号码总数，有效的号码，重复的号码数量，非法格式的号码
#   #files 文件列表   phone_numbers 号码列表
#   def file_to_phone(files, phone_numbers = nil)
#     phones = []
#     total_count = 0
#     error_count = 0
#
#     if (files.present? && files.class.to_s == 'Array')
#       files.each do |file|
#         if (file.class.to_s == 'ActionDispatch::Http::UploadedFile')
#           if (file.content_type == 'text/plain')
#             _file = file.open
#             _file.each do |line|
#               total_count += 1
#               #格式判断
#               if phone_validate(line)
#                 phones << line.lstrip.rstrip[0..10]
#               else
#                 error_count += 1
#               end
#             end
#             _file.close
#             # elsif(file.content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' || file.content_type == 'application/vnd.ms-excel')
#           elsif (file.content_type == 'application/vnd.ms-excel')
#             #处理excel
#             book = Spreadsheet.open(file.path)
#             sheet = book.worksheet 0
#             sheet.each do |row|
#               line = row[0].to_s
#               total_count += 1
#               #格式判断
#               if phone_validate(line)
#                 phones << line.lstrip.rstrip[0..10]
#               else
#                 error_count += 1
#               end
#             end
#             book = nil
#           end
#         end
#       end
#     end
#
#     if (phone_numbers.present? && phone_numbers.class.to_s == 'Array')
#       phone_numbers.each do |phone|
#         total_count += 1
#         #格式判断
#         if phone_validate(phone)
#           phones << phone.lstrip.rstrip[0..10]
#         else
#           error_count += 1
#         end
#       end
#     end
#
#     valid_phones = phones.uniq
#     info = {
#         #总号码数
#         total_count: total_count,
#         #有效号码数量
#         valid_count: valid_phones.length,
#         #无效号码数量
#         error_count: error_count,
#         #重复号码数量
#         repeated_count: phones.length - valid_phones.length
#     }
#     return valid_phones, info
#   end
#
#   #遍历读取文件
#   def read_files(files)
#     phones = {}
#     total_count = 0
#     error_count = 0
#
#     if (files.present? && files.class.to_s == 'Array')
#       files.each do |file|
#         if (file.class.to_s == 'ActionDispatch::Http::UploadedFile')
#           if (file.content_type == 'text/plain')
#             _file = file.open
#             _file.each do |line|
#               total_count += 1
#               if (!yield(:txt, line, phones))
#                 error_count += 1
#               end
#             end
#             _file.close
#             # elsif(file.content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' || file.content_type == 'application/vnd.ms-excel')
#           elsif (file.content_type == 'application/vnd.ms-excel')
#             #处理excel
#             book = Spreadsheet.open(file.path)
#             sheet = book.worksheet 0
#             sheet.each do |row|
#               total_count += 1
#               if (!yield(:excel, row, phones))
#                 error_count += 1
#               end
#             end
#             book = nil
#           end
#         end
#       end
#     end
#
#     return phones, total_count, error_count
#   end
#
#   #将上传的文件转换成号码和参数
#   #提交号码总数，有效的号码，重复的号码数量，非法格式的号码
#   #files 文件列表
#   def file_to_phone_with_params(files)
#     delimiter = ','
#     #phones: 号码列表
#     #total_count: 号码总数
#     #error_count: 错误总数
#     phones, total_count, error_count = read_files(files) do |type, data, phones|
#       if (type == :txt)
#         _data = "#{data}"
#         _data.utf8!
#         attrs = _data.split(delimiter)
#         #获取号码
#         phone = attrs.shift
#         #格式判断
#         if phone_validate(phone)
#           phone = phone.lstrip.rstrip[0..10]
#           phones[phone.to_s] = attrs
#           true
#         else
#           false
#         end
#       elsif (type == :excel)
#         attrs = []
#         col = nil
#         #遍历8列栏目
#         8.times do |index|
#           col = row[index]
#           if (col.present?)
#             attrs << col.to_s.chomp
#           else
#             break
#           end
#         end
#         #格式判断
#         phone = attrs.shift
#         if phone_validate(phone)
#           phone = phone.lstrip.rstrip[0..10]
#           phones[phone.to_s] = attrs
#           true
#         else
#           false
#         end
#       end
#     end
#
#     info = {
#         #总号码数
#         total_count: total_count,
#         #有效号码数量
#         valid_count: phones.length,
#         #无效号码数量
#         error_count: error_count,
#         #重复号码数量
#         repeated_count: total_count - error_count - phones.length
#     }
#     return phones, info
#   end
#
#   #校验手机号码
#   def phone_validate(phone)
#     /[1]\d{10}/ =~ phone.to_s
#   end
#
#   #return 0:移动,1:电信,2:联通,-1:未知
#   def phone_type_check(phone)
#     case (phone.to_s)[0..2].to_i
#       when 134, 135, 136, 137, 138, 139, 147, 150, 151, 158, 159, 157, 154, 152, 187, 188, 182, 183 then
#         0
#       when 133, 153, 189, 180, 181 then
#         1
#       when 130, 131, 132, 155, 156, 185, 186 then
#         2
#       else
#         -1
#     end
#   end
# end