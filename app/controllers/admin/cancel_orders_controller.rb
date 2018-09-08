# coding: UTF-8
class Admin::CancelOrdersController < Admin::BaseController
  before_action :base_breadcrumb

  # GET /admin/cancel_orders
  def index
    @cancel_orders = CancelOrder.where(shop_id: current_user.shop_manage_id)
  end

  def new
    class_id  = [Classification.first.id]
    class_id.concat(Classification.find(class_id[0]).children.ids)
    @shipping = Commodity.joins(:shop_commodities).where('shop_commodities.shop_id=? and commodities.classification_id in (?)', current_user.shop_manage_id, class_id).includes(:shop_commodities)
  end

  def get_shipping
    class_id  = [params[:class_id].to_i]
    class_id.concat(Classification.find(class_id[0]).children.ids)
    shipping = Commodity.joins(:shop_commodities).where('shop_commodities.shop_id=? and commodities.classification_id in (?)', current_user.shop_manage_id, class_id).as_json(include: :shop_commodities)
    render json: {shipping: shipping}
  end
  # POST /admin/cancel_orders
  def save_info
    cancel_orders = CancelOrder.new
    cancel_orders.order_id = params[:order_id]
    cancel_orders.receipt = params[:xiaopiao_id]
    cancel_orders.user_id = current_user.id
    cancel_orders.shop_id = current_user.shop_manage_id
    cancel_orders.save
    data_info  = params[:shipping_info]
    total_price = 0
    num = data_info["shipping"].count
    i=0
    while i<num do
      cancel_orders_detail  =CancelOrderDetail.new
      array_shipping = data_info["shipping"][i].split(',')
      total_price += array_shipping[2].to_f * data_info["count"][i].to_i
      cancel_orders_detail.commodity_id=array_shipping[0].to_i
      cancel_orders_detail.price = array_shipping[2].to_f
      cancel_orders_detail.count= data_info["count"][i].to_i
      cancel_orders_detail.total_amount= array_shipping[2].to_f * data_info["count"][i].to_i
      cancel_orders_detail.shop_commodity_id = array_shipping[1].to_i
      cancel_orders_detail.cancel_order_id = cancel_orders.id
      cancel_orders_detail.save
      i +=1
    end
    cancel_orders.total_amount=total_price
    cancel_orders.save
    render json: {result: 'OK'}
  end



  private
  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.cancel_order.admin_title'), admin_cancel_orders_path
  end
end