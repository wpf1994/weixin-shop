class Attachment < ActiveRecord::Base
  enum data_type: {normal: 0}

  belongs_to :author, class_name: 'User'
  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/images/:style/missing.png'
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

end
