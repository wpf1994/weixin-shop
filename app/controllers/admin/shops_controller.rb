# coding: UTF-8
class Admin::ShopsController < Admin::BaseController
  load_and_authorize_resource
  before_action :base_breadcrumb
  before_action :set_shop, only: [:show, :edit, :update, :destroy]
  before_action :name_breadcrumb_handler, only: [:show, :edit]
  before_action :action_common_breadcurmb, only: [:new, :edit]
  # GET /admin/shops
  def index
    @shops = initialize_grid(Shop, page: params[:page], order: :created_at, order_direction: :desc)
  end

  # GET /admin/shops/1
  def show
  end

  # GET /admin/shops/new
  def new
    @shop = Shop.new
  end

  # GET /admin/shops/1/edit
  def edit
  end

  # POST /admin/shops
  def create
    @shop = Shop.new(shop_params)

    respond_to do |format|
      if @shop.save
        Commodity.all.each do |c|
          ShopCommodity.create(shop_id: @shop.id, commodity_id: c.id, price: c.reference_price, sales_volume: 0, position: 0)
        end
        #创建对应user
        user = User.create(owner: @shop, name: "#{@shop.name}账号", email: "#{@shop.phone}@qq.com", phone: @shop.phone, password: 12345678, password_confirmation: 12345678,shop_manage_id:@shop.id)
        #给user添加权限
        UserRole.create({user_id: user.id, role_id: 2})

        format.html { redirect_to admin_shop_path(@shop.id), notice: create_success_notice(:shop) }
       format.json { render action: 'show', status: :created, location: @shop }
      else
        format.html { render action: 'new' }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/shops/1
  def update
    respond_to do |format|
      if @shop.update_attributes(shop_params)
       format.html { redirect_to admin_shop_path(@shop.id), notice: update_success_notice(:shop) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/shops/1
  def destroy
    begin
      @shop.destroy
    rescue
      @shop.update_attributes(enable: false)
    end

    respond_to do |format|
      format.html { redirect_to admin_shops_path, notice: destroy_success_notice(:shop) }
      format.json { head :no_content }
    end
  end

  def destroy_multi
    ids =params[:grid][:select_ids]
    if ids and ids.instance_of? Array
      ids.each do |id|
        shop = Shop.find(id)
        begin
          shop.destroy! if shop
        rescue ActiveRecord::RecordNotDestroyed
          shop.update_attributes(enable: false)
          next
        end
      end
    end
  rescue
    flash[:notice] ="#{t 'common.delete_multi'}#{t 'common.fault'}"
    redirect_to action: 'index'
  else
    flash[:notice] ="#{t 'common.delete_multi'}#{t 'common.success'}"
    redirect_to action: 'index'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_shop
    if params[:action] == 'show'
       @shop = Shop.find(params[:id])
    else
      @shop = Shop.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def shop_params
    params.require(:shop).permit(:name, :address, :phone, :map_location, :region_id, :parent_id, :can_express, :express_amount, :can_express_start_date, :can_express_end_date)
  end

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.shop.admin_title'), admin_shops_path
  end

  # add name breadcrumb with :show, :edit
  def name_breadcrumb_handler
    add_breadcrumb @shop.name, admin_shop_path(@shop.id), class: :pjax
  end
end