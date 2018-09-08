class Admin::BaseController < ApplicationController
  include BreadcurmbModule
  layout :admin_layout
  def admin_layout
    request.headers['X-PJAX'] ? 'admin/pjax' : 'admin/application'
  end
  before_action :authenticate_user!#, unless: [:other_controller]
  def after_sign_in_path_for(resource = nil)
    path = nil
    if(can? :manage, User)
      #超级管理员
      path = admin_users_path
    elsif(can? :read, Customer)
      #经理
      path = admin_customers_path
    elsif(can? :update, CancelOrder)
      #商店管理员
      path = admin_manage_orders_path
    elsif(current_user.owner_type == 'Employee')
      #销售员
      path = '/front/homes/express'
    end
    if(resource)
      return path
    else
      redirect_to(path)
    end
  end
end