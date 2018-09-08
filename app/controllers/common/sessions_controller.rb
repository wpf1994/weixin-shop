class Common::SessionsController < Devise::SessionsController
  layout 'common/blank'
  before_action :authenticate_user!#, unless: [:other_controller]
  def after_sign_in_path_for(resource = nil)
    path = nil
    if(can? :manage, User)
      #超级管理员
      path = admin_users_path
    elsif(can? :read, Customer)
      #经理
      path = admin_customers_path
    elsif(can? :update, CancelOrder || current_user.owner_type == 'Shop')
      #商店管理员
      path = admin_cancel_orders_path
    elsif(current_user.owner_type == 'Employee')
      #销售员
      path = '/front/homes/express'
    end
    p path
    if(resource)
      return path
    else
      redirect_to(path)
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    '/admin'
  end
end