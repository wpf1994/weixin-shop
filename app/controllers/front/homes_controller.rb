# coding: UTF-8
class Front::HomesController < Front::BaseController
  include  Front::HomesHelper

  layout :false
  before_action :authenticate_user!, only: [:express]

  def home
    # user_info, has_redirect = oauth2_weixin
    # return if has_redirect
    # temp = JSON.parse(user_info.to_json)
    # result = temp["result"]
    # user = User.joins('inner join customers on customers.id=users.owner_id and users.owner_type="Customer"').find_by('customers.weixin_id=?', result["openid"])
    # if user.present?
    #   sign_in user
    # else
    #   customer =  Customer.new
    #   customer.weixin_id = result["openid"]
    #   customer.name = result["nickname"].to_s
    #   customer.save!
    #   @user = User.create(owner: customer, name:  result["nickname"].to_s, email: "customer_#{customer.id}@qq.com", phone: phone_isunique!, password: 12345678, password_confirmation: 12345678)
    #   @user.save!
    #   sign_in @user
    # end
  end


  def express
    @order_express = OrderExpress.joins(:order).where(orders: {status: 4}, order_expresses: {user_id: current_user.owner_id}).order(created_at: :asc)
    render 'front/expresser'
  end
  def express_entrue
    current_time = Time.now
    order_info = Order.find(params[:order_id])
    order_info.status=5
    order_info.complete_date = current_time
    order_info.save!
    order_info.order_express.update({complete_date: current_time, is_ontime: (current_time <= order_info.order_express.express_end_time)})
    render json: {result: 'OK'}
  end
  #首页
  def home_index
    #获取默认商品
    class_id  = [params[:class_id].to_i || Classification.first.id]
    class_id.concat(Classification.find(class_id[0]).children.ids)
    @shopping = Commodity.select('shop_commodities.price AS price, shop_commodities.id AS sc_id, commodities.*')
                    .joins(:shop_commodities, :classification)
                    .where('shop_commodities.shop_id=? and (shop_commodities.left_count>0 or shop_commodities.is_has_long=true) and commodities.classification_id IN (?) and shop_commodities.enable = true', (params[:shop_id].to_i == 0 ? nil: params[:shop_id].to_i) || Shop.first.id, class_id)
                   .page(params[:page] || 0).per(params[:per] || 10)
                   # .as_json(include: [:shop_commodities,:cover, {cover: { methods: :avatar}}])
    # render json: {shipping: shipping}
  end
  # #搜索子菜单下面的商品
  # def children_shipping
  #   @shopping = Commodity.select('shop_commodities.price AS price, shop_commodities.id AS sc_id, commodities.*').joins(:shop_commodities).where('shop_commodities.shop_id=? and commodities.classification_id=?', (params[:shop_id].to_i == 0 ? nil: params[:shop_id].to_i) || Shop.first.id, params[:class_id].to_i || Classification.first.id)
  #                   .page(params[:page] || 0).per(params[:per] || 10)
  # end
  #获取类型
  def get_classification
    classifications = Classification.where(parent_id: nil).as_json(include: :children)
    render json: {classifications: classifications}
  end

  #个人中心
  #获取用户个人信息
  def get_person_info
    # person_info  =  Customer.find(id: current_user.id)
    user  =  User.select(:owner_id).find(current_user.id)
    person_info = Customer.find(user.owner_id)

    render json: {person_info: person_info}
  end

  def get_order_old
    #获取用户完成的订单
    order_info = Order.where(customer_id: current_user.id, status: [5,6,-1,-2,-3]).order(created_at: :asc).page(params[:page]).per(params[:per]).as_json(include: :shop)
    render json: {order_info: order_info}
  end

  def get_order_ing
    #获取用户正在进行的订单
    order_info = Order.where(customer_id: current_user.id, status: [0,1,2,3,4]).order(created_at: :desc).as_json(include: :shop)
    render json: {order_info: order_info}
  end

  def get_order_detail
    #获取订单详细信息
    order_detail = OrderDetail.includes(:commodity).where(order_id: params[:order_id]).all.as_json(include: {commodity: {include: :classification}})
    order_expresss = OrderExpress.find_by(order_id: params[:order_id])
    order_info = Order.find(params[:order_id])
    shop = Shop.find(order_info.shop_id)
    render json: {order_detail: order_detail, order_expresss: order_expresss, order_info: order_info, shop: shop}
  end
  def get_score_detail
    #获取积分记录
    score_record = ScoreRecord.where(customer_id: current_user.id).order(updated_at: :asc)
    render json: {score_record: score_record}
  end

  #收货地址
  def shipping_address
    #获取收货地址
    receiving_address = ReceivingAddress.where(customer_id: current_user.owner_id).order(created_at: :asc).all
    render json: {receiving_address: receiving_address}
  end

  # #送货员
  # def deliver
  #   #获取待派送的货品
  #   order_express = OrderExpress.joins(:order).where('order.status=? and order_express.user_id=?', 5, current_user.id).order(created_at: :asc).all
  #   render json: {order_express: order_express}
  # end


  #获取商品分类
  def get_shipping_class
    classification = Classification.page(params[:page]||0).per(params[:per]||10)
    render json: {classification: classification}
  end

  #新建或保存更新收货地址
  #获取默认地址
  def shipping_address_default
    receiving_address = ReceivingAddress.where(customer_id: current_user.owner_id, is_default: true).first
    render json: {receiving_address: receiving_address}
  end
  #新建
  def shipping_address_new
    shipping_address = ReceivingAddress.new params.require(:receiving_address).permit!
    shipping_address.customer_id =current_user.owner_id
    if shipping_address.is_default
      address = ReceivingAddress.where(is_default: true)
    end
    address.each do |c|
      c.is_default = false
      c.save!
    end
    shipping_address.save!
    render json: {result: 'OK', result_address_id: shipping_address.id}
  end

  #更新
  def shipping_address_change
    shipping_address = ReceivingAddress.find(params[:receiving_address][:id])
    shipping_address.update_attributes! params.require(:receiving_address).except(:id).permit!
    render json: {result: 'OK',result_address_id: shipping_address.id}
  end

  #新建订单
  def order_new
    #新建订单
    order_info = Order.new params.require(:order).permit!
    if order_info.shop_id == nil
      order_info.shop_id = Shop.first.id
    end
    order_info.customer_id = current_user.id
    order_info.status = 3
    order_info.commodity_amount = order_info.commodity_amount || 0
    order_info.express_amount = order_info.express_amount || 0
    order_info.total_amount = order_info.total_amount || 0
    order_info.consume_amount = order_info.consume_amount || 0
    order_info.total_amount = order_info.commodity_amount + order_info.express_amount
    order_info.actual_amount = order_info.total_amount - order_info.consume_amount
    order_info.pay_style = 0
    order_info.save
    #新建订单明细
    temp  = params.require(:order_detail).permit!
    dummy_count = 0.0
    temp[:shipping].each do |shopname, array|
      array.each  do |n|
        order_detail = OrderDetail.new
        order_detail.order_id = order_info.id
        order_detail.commodity_id = n[:id]
        order_detail.shop_commodity_id = n[:shop_commodities][:id]
        order_detail.price = n[:shop_commodities][:price]
        order_detail.count = n[:num]
        order_detail.total_amount = n[:shop_commodities][:price] * n[:num]
        order_detail.save
        sq =  (n[:shop_commodities][:id]).to_i
        shop_commodity = ShopCommodity.find(sq)
        shop_commodity.sales_volume = shop_commodity.sales_volume || 0
        shop_commodity.sales_volume += order_detail.count
        shop_commodity.save!

        if n[:is_fictitious] == true
          dummy_shop_order= DummyShopOrder.new
          dummy_shop_order.commodity_name = n[:name]
          dummy_shop_order.commodity_num = n[:num]
          dummy_shop_order.user_name = params[:order_express][:name]
          dummy_shop_order.user_phone = params[:order_express][:phone]
          dummy_count += (dummy_shop_order.commodity_num.to_i * n[:shop_commodities][:price].to_f).round(2)
          dummy_shop_order.save
        end

        end
    end
    order_info.fictitious_commodity_amount= dummy_count
    order_info.material_commodity_amount= (order_info.actual_amount.to_f  - order_info.fictitious_commodity_amount.to_f).round(2)
    order_info.save

    #用户加分
    customer = Customer.find(current_user.owner_id)
    customer.score  = customer.score || 0
    customer.score += order_info.actual_amount
    customer.save!
    #积分记录
    score_record = ScoreRecord.new
    score_record.customer_id = current_user.id
    score_record.is_plus = true
    score_record.reason = "消费#{order_info.actual_amount}元,+#{order_info.actual_amount}分"
    score_record.save!

    #订单配送表
    stemp = params[:order_express]
    order_express = OrderExpress.new
    order_express.order_id = order_info[:id]
    order_express.address = stemp[:address]
    order_express.phone = stemp[:phone]
    order_express.name = stemp[:name]
    # order_express.updated_at = nil
    order_express.save

    #判断是否支付
    if params[:pay_style].to_i == 1
      #更新订单状态
      order_info.update status:1, pay_style: 1
      #设置微信下单参数
      response,result_info,params_info = set_pay_option(order_info.total_amount*100,order_info.id)
      #存储微信下单记录
      order_place_in = OrderPlaceIn.new
      order_place_in.order_id = order_info.id
      order_place_in.out_trade_no = params_info[:out_trade_no]
      order_place_in.cash_fee = params_info[:total_fee]
      order_place_in.status = 0
      order_place_in.save
      render json: {response: response,result: 'OK'}
    else
      render json: {result: 'OK'}
    end
  end

  def set_pay_option(pay_money,order_id)
    # required fields
    ip = request.headers['X-Real-IP']||request.headers['X-FORWARDED-FOR']||request.ip
    params = {
        body: '商品购物',
        out_trade_no: Time.now.to_i,
        total_fee: pay_money.to_i,
        spbill_create_ip: ip,
        notify_url: 'http://www.cqpssm.net/front/homes/pay_call_back',
        trade_type: 'JSAPI',
        attach: "#{order_id}", #附件的信息,订单的编号
        openid: session[:weixin_openid],
    }
    result_info = WxPay::Service.invoke_unifiedorder params
    response = {
        appId: result_info["appid"],
        timeStamp: Time.new.to_i.to_s,
        nonceStr: SecureRandom.uuid.tr('-', ''),
        package: "prepay_id=#{result_info['prepay_id']}",
        signType: "MD5"
    }
    query = response.sort.map do |key, value|
      "#{key}=#{value}"
    end.join('&')

    response[:paySign] = Digest::MD5.hexdigest("#{query}&key=#{WxPay.key}").upcase
    return response,result_info,params
  end

  #获取商店的所有所属区域
  def get_region_shop
    @shop_area = CodeTable.joins(:shops).where('code_tables.parent_id=?',1).includes(:shops)
    # render json: {shop_area: shop_area}
  end

  #获取商店
  def get_shop
    shop  = Shop.where(region_id: params[:region_id]).page(params[:page]||0).per(params[:per]||10)
    # shop = CodeTable.where(parent_id: 1).includes(:shops).where(:shops => {region_id: params[:region_id]}).page(params[:page]||0).per(params[:per]||10).as_json(include: :shops)
    render json: {shop: shop}
  end

  #获取更改后的店铺商品
  def shop_commodity_change
    shop_info = Shop.includes(:shop_commodities).where(id: params[:id]).first.as_json(include: {shop_commodities: {include: :commodity}})

    shop_info.shop_commodities.includes(:commodity).page(params[:page]||0).per(params[:per]||10)
    shop_commodity = shop_info.as_json(include: :commodities)
    shop_commodity
  end

  #获取更多的商品信息
  def get_more_commodity
    shop_info = Shop.includes(:shop_commodities).where(id: params[:id]).first
    shop_info.shop_commodities.includes(:commodity).page(params[:page]||0).per(params[:per]||10)
    shop_commodity = shop_info.as_json(include: :ccommodity)
    shop_commodity
  end

  #在线支付
  def pay_view
    open_id = authenticate_openid! if request.headers['User-Agent'] && request.headers['User-Agent'].index('MicroMessenger')
  end


  def pay_online
    # required fields
    open_id = session[:weixin_openid] || authenticate_openid! if request.headers['User-Agent'] && request.headers['User-Agent'].index('MicroMessenger')
    ip = request.headers['X-Real-IP']||request.headers['X-FORWARDED-FOR']||request.ip
    order_id = params[:id].to_s
    order_info = Order.find(order_id)
    total_fee = order_info.total_amount*100
    params = {
        body: '商品购物',
        out_trade_no: Time.now.to_i,
        total_fee: total_fee.to_i,
        spbill_create_ip: ip,
        notify_url: 'http://www.cqpssm.net/front/homes/pay_call_back',
        trade_type: 'JSAPI',
        attach: order_id, #附件的信息,订单的编号
        openid: open_id#'oKnWxt4t9jy1o86TtFRbnOZ_PEJU',
    }
    result_info = WxPay::Service.invoke_unifiedorder params
    response = {
        appId: result_info["appid"],
        timeStamp: Time.new.to_i.to_s,
        nonceStr: SecureRandom.uuid.tr('-', ''),
        package: "prepay_id=#{result_info['prepay_id']}",
        signType: "MD5"
    }
    query = response.sort.map do |key, value|
      "#{key}=#{value}"
    end.join('&')

    response[:paySign] = Digest::MD5.hexdigest("#{query}&key=#{WxPay.key}").upcase

    #存储微信下单记录
    order_place_in = OrderPlaceIn.new
    order_place_in.order_id = order_info.id
    order_place_in.out_trade_no = params[:out_trade_no]
    order_place_in.cash_fee = params[:total_fee]
    order_place_in.status = 0
    order_place_in.save
    render json: {response: response}
  end

  def pay_call_back
    result = Hash.from_xml(request.body.read)["xml"]

    if WxPay::Sign.verify?(result)

      order_place_in = OrderPlaceIn.find_by(out_trade_no: result["out_trade_no"])
      if order_place_in.present?
        order_place_in.update status: 1
        #新建支付回调记录
        call_back_new = CallBackBill.new
        call_back_new.cash_fee = result["cash_fee"]
        call_back_new.order_id = result["attach"].to_i
        call_back_new.order_place_in_id = order_place_in.id
        call_back_new.out_trade_no = result["out_trade_no"]
        call_back_new.transaction_id = result["transaction_id"]
        call_back_new.save
        order_info = Order.find(result["attach"].to_i)
        order_info.update status: 3
        #更新虚拟商品的状态
        order_info.dummy_shop_orders.update_all is_fund: true
      end
      render :xml => {return_code: "SUCCESS"}.to_xml(root: 'xml', dasherize: false)
    else
      render :xml => {return_code: "FAIL", return_msg: "签名失败"}.to_xml(root: 'xml', dasherize: false)
    end
  end

  #评价
  def commentary_order
    commentary =  OrderComment.new params.require(:order_comment).permit!
    commentary.save
    order = Order.find(commentary.order_id)
    order.status = 6
    order.save
    render json: {result: 'OK'}
  end

  #取消订单
  def cancel_order_customer
    order = Order.find(params[:order_id])
    order.status = -1
    order.save!
    render json: {result: 'OK'}
  end
  #修改用户信息
  def change_person_info
    user = User.find(current_user.id)
    user.name = params[:person_info][:name]
    user.owner.name = user.name
    user.owner.save!
    user.save!
    render json: {result: 'OK'}
  end
  #搜索商品
  def search_shipping_info
    abc= "%"+params[:shipping_name]+"%"
    # @shipping_search_info = ActiveRecord::Base.connection.select_all("SELECT shop_commodities.price AS price, shop_commodities.id AS sc_id, commodities.* FROM commodities INNER JOIN shop_commodities ON `shop_commodities`.`commodity_id` = `commodities`.`id` WHERE shop_commodities.shop_id=1 and commodities.name like N'"+abc+"'")
    @shipping_search_info = Commodity.select('shop_commodities.price AS price, shop_commodities.id AS sc_id, commodities.*').joins(:shop_commodities, :classification).where('shop_commodities.shop_id=? and commodities.name like N?', (params[:shop_id].to_i == 0 ? nil: params[:shop_id].to_i) || Shop.first.id,abc )

    # render json: {shipping_search_info: shipping_search_info}
  end
end