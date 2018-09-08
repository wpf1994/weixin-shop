class Permission < ActiveRecord::Base
  belongs_to :group, class_name: 'CodeTable'

  has_many :role_permissions, dependent: :delete_all
  has_many :roles, through: :role_permissions

  # validate :validate_action_value
  #
  # def validate_action_value
  #   unless self.action.start_with? ':'
  #     errors.add(:action, "请用冒号开始，如: ':manage'")
  #   end
  # end

  def use_subject
    if self.subject == 'all'
      self.subject.to_sym
    else
      self.subject.constantize
    end
  end

  def use_action
    eval(self.action)
  end

end
