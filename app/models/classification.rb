class Classification < ActiveRecord::Base
  belongs_to :parent, class_name: 'Classification'
  has_many :children, -> {order position: :asc}, class_name: 'Classification', foreign_key: 'parent_id'
  acts_as_list scope: :parent
end
