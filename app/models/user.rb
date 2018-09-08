class User < ActiveRecord::Base
  attr_accessor :phone_cache
  attr_accessor :current_password
  attr_accessor :password_confirmation
  attr_accessor :login

  #validates :phone, presence: true, length: {minimum: 11, maximum: 11}, uniqueness: true
  validates :email, presence: false, length: {maximum: 50}, uniqueness: true, format: /@/, allow_nil: true

  belongs_to :owner, polymorphic: true
  belongs_to :organization
  #角色
  has_many :user_roles, dependent: :delete_all
  has_many :roles, through: :user_roles
  has_many :permissions, through: :roles
  accepts_nested_attributes_for :user_roles

  belongs_to :manage_shop, class_name: 'Shop', foreign_key: 'shop_manage_id'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]


  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(['lower(phone) = :value OR lower(email) = :value', {:value => login.downcase}]).first
    else
      where(conditions.to_h).first
    end
  end
end
