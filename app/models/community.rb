class Community < ActiveRecord::Base
  belongs_to :region, class_name: 'CodeTable', foreign_key: 'region_id'
  has_many :receiving_addresses
  belongs_to :kind_name, class_name: 'CodeTable', foreign_key: 'kind'
end
