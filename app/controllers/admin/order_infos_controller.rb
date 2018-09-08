# coding: UTF-8
class Admin::OrderInfosController < Admin::BaseController

  before_action :base_breadcrumb

  # GET /admin/manage_orders
  def index
    @status_option = ['用户下单','等待支付','等待确认','等待配送','配送中', '待评价', '已评价']
    @manage_orders = OrderExpress.joins(:order).where(orders: {status: [4,5,6], shop_id: current_user.shop_manage_id}).page(params[:page])
  end

  # GET /admin/manage_orders/1
  def show
  end
  private

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.order_info.admin_title'), admin_manage_orders_path
  end
end