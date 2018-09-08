class Admin::ShopStatisticsController < Admin::BaseController

  before_action :base_breadcrumb
  #首页
   def index
   end
   #备货超时订单统计
  def get_data
    minutes = (params[:minutes]).to_i
    time_info = params[:time_info]
    if time_info[0] ==""
      end_time = DateTime.now
      start_time = DateTime.new(end_time.year, end_time.month, 1)
    else
      end_time = time_info[1]
      start_time = time_info[0]
    end
    if current_user.roles.find_by('roles.id=1').present?
      @temp =  ActiveRecord::Base.connection.select_all( "SELECT COUNT(orders.id) AS count_all, shops.name AS shop_name FROM orders INNER JOIN shops ON orders.shop_id=shops.id WHERE orders.status IN (5,6) AND ((orders.set_out_at-orders.created_at)/60>#{minutes}) AND orders.created_at BETWEEN '#{start_time}' AND '#{end_time}' GROUP BY shop_id")
    else
      @temp =  ActiveRecord::Base.connection.select_all( "SELECT COUNT(orders.id) AS count_all, shops.name AS shop_name FROM orders INNER JOIN shops ON orders.shop_id=shops.id WHERE orders.status IN (5,6) AND ((orders.set_out_at-orders.created_at)/60>#{minutes}) AND orders.created_at BETWEEN '#{start_time}' AND '#{end_time}' AND orders.shop_id=#{current_user.shop_manage_id}")
    end
    name = []
    data = []
    @temp.each do |c|
      name.push(c["shop_name"])
      data.push(c["count_all"])
    end
    render json:  {name: name, data: data, temp: @temp}
  end
  #订单数量统计
  def shop_total
    time_info = params[:time_info]
    if time_info[0] ==""
      end_time = DateTime.now
      start_time = DateTime.new(end_time.year, end_time.month, 1)
    else
      end_time = time_info[1].to_datetime
      start_time = time_info[0].to_datetime
    end
    if current_user.roles.find_by('roles.id=1').present?
      temp =  ActiveRecord::Base.connection.select_all( "SELECT COUNT(orders.id) AS count_all, shops.name AS shop_name FROM orders INNER JOIN shops ON orders.shop_id=shops.id WHERE orders.status IN (5,6) AND orders.created_at BETWEEN '#{start_time}' AND '#{end_time}' GROUP BY shop_id")
    else
      temp =  ActiveRecord::Base.connection.select_all( "SELECT COUNT(orders.id) AS count_all, shops.name AS shop_name FROM orders INNER JOIN shops ON orders.shop_id=shops.id WHERE orders.status IN (5,6) AND orders.created_at BETWEEN '#{start_time}' AND '#{end_time}' AND orders.shop_id=#{current_user.shop_manage_id}")
    end
    name = []
    data = []
    temp.each do |c|
      name.push(c["shop_name"])
      data.push(c["count_all"])
    end
    render json:  {name: name, data: data, temp: temp}
  end
  #销售金额统计
  def shop_all_total
    time_info = params[:time_info]
    if time_info[0] ==""
      end_time = DateTime.now
      start_time = DateTime.new(end_time.year, end_time.month, 1)
    else
      end_time = time_info[1].to_datetime
      start_time = time_info[0].to_datetime
    end
    if current_user.roles.find_by('roles.id=1').present?
      temp =  ActiveRecord::Base.connection.select_all( "SELECT SUM(orders.actual_amount) AS count_all, shops.name AS shop_name,SUM(orders.material_commodity_amount) AS material_count_all,SUM(orders.fictitious_commodity_amount) AS fictitious_count_all FROM orders INNER JOIN shops ON orders.shop_id=shops.id WHERE orders.status IN (5,6) AND orders.created_at BETWEEN '#{start_time}' AND '#{end_time}' GROUP BY shop_id")
      single_temp =  ActiveRecord::Base.connection.select_all( "SELECT SUM(order_details.total_amount) as count_sum, orders.shop_id, classifications.name,classifications.id as class_id  FROM order_details left JOIN orders ON order_details.order_id=orders.id left join commodities on commodities.id=order_details.commodity_id left join classifications on classifications.id = commodities.classification_id where orders.created_at BETWEEN '#{start_time}' AND '#{end_time}' group by classifications.id, orders.shop_id")

    else
      temp =  ActiveRecord::Base.connection.select_all( "SELECT SUM(orders.actual_amount) AS count_all, shops.name AS shop_name,SUM(orders.material_commodity_amount) AS material_count_all,SUM(orders.fictitious_commodity_amount) AS fictitious_count_all FROM orders INNER JOIN shops ON orders.shop_id=shops.id WHERE orders.status IN (5,6) AND orders.created_at BETWEEN '#{start_time}' AND '#{end_time}' AND orders.shop_id=#{current_user.shop_manage_id}")
      single_temp =  ActiveRecord::Base.connection.select_all( "SELECT SUM(order_details.total_amount) as count_sum, orders.shop_id, classifications.name,classifications.id as class_id  FROM order_details left JOIN orders ON order_details.order_id=orders.id left join commodities on commodities.id=order_details.commodity_id left join classifications on classifications.id = commodities.classification_id where orders.created_at BETWEEN '#{start_time}' AND '#{end_time}' AND orders.shop_id=#{current_user.shop_manage_id} group by classifications.id")
    end
    name = []
    data = []
    temp.each do |c|
      name.push(c["shop_name"])
      data.push(c["count_all"].round(2))
    end
    new_single_temp = {}
    single_temp.each do |c|
      if c["class_id"].present?
        parent_class_name = Classification.find(c["class_id"])
        is_true_class = parent_class_name.parent.present? ? parent_class_name.parent.single_statistics : parent_class_name.single_statistics
        if is_true_class
          parent_class_name = parent_class_name.parent.present? ? parent_class_name.parent.name : parent_class_name.name
          new_temp = {}
          new_temp["shop_name"] = Shop.find(c["shop_id"]).name
          new_temp["count_all"] = c["count_sum"]
          new_single_temp[parent_class_name]  = new_single_temp[parent_class_name] || {}
          if new_single_temp[parent_class_name]["shop_name"] == new_temp["shop_name"]
            new_single_temp[parent_class_name]["count_all"] = (new_single_temp[parent_class_name]["count_all"].to_f + new_temp["count_all"].to_f).round(2)
          else
            new_single_temp[parent_class_name] = new_temp
          end
        end
      end
    end
    # Classification.where('parent_id is null and single_statistics=true')

    render json:  {name: name, data: data, temp: temp, new_single_temp: new_single_temp}
  end

  #热销商品排序
  #全店统计
  def hot_shipping_total
    time_info = params[:time_info]
    if time_info[0] ==""
      end_time = DateTime.now
      start_time = DateTime.new(end_time.year, end_time.month, 1)
    else
      end_time = time_info[1].to_datetime
      start_time = time_info[0].to_datetime
    end
    temp =  ActiveRecord::Base.connection.select_all( "SELECT SUM(order_details.count) AS count_all, commodities.name AS shop_name FROM orders INNER JOIN order_details INNER JOIN commodities INNER JOIN shops ON orders.id=order_details.order_id AND order_details.commodity_id=commodities.id AND orders.shop_id=shops.id WHERE orders.created_at BETWEEN '#{start_time}' AND '#{end_time}' GROUP BY commodities.id order by count_all desc ").take(20)
    name = []
    data = []
    temp.each do |c|
      name.push(c["shop_name"])
      data.push(c["count_all"])
    end
    render json:  {name: name, data: data, temp: temp}
  end
  #热销商品单店统计
  def hot_shipping_single
    shop_id = params[:shop_id]
    time_info = params[:time_info]
    if time_info[0] ==""
      end_time = DateTime.now
      start_time = DateTime.new(end_time.year, end_time.month, 1)
    else
      end_time = time_info[1].to_datetime
      start_time = time_info[0].to_datetime
    end
    temp =  ActiveRecord::Base.connection.select_all( "SELECT SUM(order_details.count) AS count_all, commodities.name AS shop_name FROM orders INNER JOIN order_details INNER JOIN commodities INNER JOIN shops ON orders.id=order_details.order_id AND order_details.commodity_id=commodities.id AND orders.shop_id=shops.id WHERE shops.id=#{shop_id} AND orders.created_at BETWEEN '#{start_time}' AND '#{end_time}' GROUP BY commodities.id")
    name = []
    data = []
    temp.each do |c|
      name.push(c["shop_name"])
      data.push(c["count_all"])
    end
    render json:  {name: name, data: data, temp: temp}
  end
  #递送员单量统计
  def express_num_total
    time_info = params[:time_info]
    if time_info[0] ==""
      end_time = DateTime.now
      start_time = DateTime.new(end_time.year, end_time.month, 1)
    else
      end_time = time_info[1].to_datetime
      start_time = time_info[0].to_datetime
    end
    temp =  ActiveRecord::Base.connection.select_all( "SELECT COUNT(orders.id) AS count_all, users.name AS user_name , shops.name AS shop_name FROM orders INNER JOIN order_expresses INNER JOIN shops INNER JOIN users ON orders.id=order_expresses.order_id AND shops.id=orders.shop_id AND order_expresses.user_id=users.id WHERE orders.created_at BETWEEN '#{start_time}' AND '#{end_time}' GROUP BY shops.id, order_expresses.user_id ORDER BY shops.id,count_all DESC")
    name = []
    data = []
    user = []
    temp.each do |c|
      name.push(c["shop_name"])
      data.push(c["count_all"])
      user.push(c["user_name"])
    end
    render json:  {name: name, data: data, temp: temp, user: user}
  end
   private

   def base_breadcrumb
     add_breadcrumb (t 'activerecord.attributes.shop_statistics.admin_title'), admin_manage_orders_path
   end
end