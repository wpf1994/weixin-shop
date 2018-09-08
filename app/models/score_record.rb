class ScoreRecord < ActiveRecord::Base
  belongs_to :customer
  belongs_to :order, class_name: 'Order', foreign_key: 'relation_id'
end
