json.array!(@admin_adverts) do |admin_advert|
  json.extract! admin_advert, :id, :name, :title, :link
  json.url admin_advert_url(admin_advert, format: :json)
end
