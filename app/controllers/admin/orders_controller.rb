# coding: UTF-8
class Admin::OrdersController < Admin::BaseController
  load_and_authorize_resource
  before_action :base_breadcrumb
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :name_breadcrumb_handler, only: [:show, :edit]
  before_action :action_common_breadcurmb, only: [:new, :edit]
  # GET /admin/orders
  def index
    if !current_user.permissions.find_by(subject: 'all').present?
      @orders = initialize_grid(Order.where(shop_id: current_user.shop_manage_id).accessible_by(current_ability, :manage), page: params[:page], order: :created_at, order_direction: :desc)
    else
      @orders = initialize_grid(Order.accessible_by(current_ability, :manage), page: params[:page], order: :created_at, order_direction: :desc)
    end
    @status_option = ['用户下单','等待支付','等待确认','等待配送','配送中', '待评价', '已评价']
  end



  private
  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.order.admin_title'), admin_orders_path
  end

  # add name breadcrumb with :show, :edit
  def name_breadcrumb_handler
    add_breadcrumb '订单信息', admin_order_path(@order.id), class: :pjax
  end
end