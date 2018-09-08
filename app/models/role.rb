class Role < ActiveRecord::Base
  has_many :role_permissions, dependent: :delete_all, autosave: true
  has_many :permissions, through: :role_permissions
  accepts_nested_attributes_for :role_permissions
end
