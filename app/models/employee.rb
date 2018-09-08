class Employee < ActiveRecord::Base
  belongs_to :shop
  has_attached_file :photo, styles: {medium: '300x300>', thumb: '100x100>'}, default_url: '/images/:style/missing.png'
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

  has_one :user, foreign_key: 'owner_id'
end
