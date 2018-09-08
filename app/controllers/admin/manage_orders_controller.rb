# coding: UTF-8
class Admin::ManageOrdersController < Admin::BaseController

  before_action :base_breadcrumb

  # GET /admin/manage_orders
  def index
    @status_option = ['用户下单','等待支付','等待确认','等待配送','配送中', '待评价', '已评价']
    @manage_orders = OrderExpress.joins(:order).where(orders: {status: 3, shop_id: current_user.shop_manage_id}).page(params[:page])
  end

  # GET /admin/manage_orders/1
  def show
  end

  #读取未送货数量
  def read_order_count
    count = Order.where(status: 3, shop_id: current_user.shop_manage_id).count
    render json: count
  end

  #添加送货员
  def add_express_seller
    temp = params[:order_express_id]
    stemp = params[:seller_id]
    order_id = params[:order_id]

    current_time = Time.now

    #更新订单
    order = Order.find(order_id)
    order.status = 4
    order.set_out_at= current_time
    order.save!
    #更新商品销量
    order.order_details.each do |temp|
      temp.shop_commodity.sales_volume +=temp.count
      if temp.shop_commodity.is_has_long == false
        temp.shop_commodity.left_count -=temp.count
      end
      temp.shop_commodity.save
    end

    #创建订单日志信息
    order_log = OrderLog.new
    order_log.user_id = current_user.id
    order_log.order_id = order_id
    order_log.status = 3
    order_log.is_system= false
    order_log.save!
    #更新送货表
    order_express = OrderExpress.find(temp)
    order_express.user_id = stemp
    order_express.express_start_time = current_time
    #查询送货预计时间
    ex_time = 10  #CodeTable.find(2).default_value.to_i
    order_express.express_end_time = current_time + ex_time.minutes
    order_express.save!

    render json: {result: 'OK'}
  end
  private

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.manage_order.admin_title'), admin_manage_orders_path
  end

end