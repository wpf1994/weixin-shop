class Admin::DummyShopOrdersController < Admin::BaseController

  before_action :base_breadcrumb, only: [:index]

  def index
    @dummy_shop_orders = initialize_grid(DummyShopOrder.where(is_fund: true), page: params[:page], order: :created_at, order_direction: :desc)
  end

  def base_breadcrumb
    add_breadcrumb '虚拟商品订单管理', '',class: :pjax
  end
end