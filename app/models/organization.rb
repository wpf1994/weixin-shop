class Organization < ActiveRecord::Base
  belongs_to :parent, class_name: 'Organization'

  acts_as_nested_set
end
