json.success true
json.set! :data do
  json.partial! @partial || nill
end
json.errorCode @error_code || nil
json.message @result_message || nil