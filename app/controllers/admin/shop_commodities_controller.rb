# coding: UTF-8
class Admin::ShopCommoditiesController < Admin::BaseController
  load_and_authorize_resource
  before_action :base_breadcrumb
  before_action :set_shop_commodity, only: [:show, :edit, :update, :destroy]
  before_action :name_breadcrumb_handler, only: [:show, :edit]
  before_action :action_common_breadcurmb, only: [:new, :edit]
  # GET /admin/shop_commodities
  def index
    if !current_user.permissions.find_by(subject: 'all').present?
      @shop_commodities = initialize_grid(ShopCommodity.joins(:commodity, :shop).where(shop_id: current_user.shop_manage_id).accessible_by(current_ability,:manage), page: params[:page], order: :left_count, order_direction: :asc)
    else
      @shop_commodities = initialize_grid(ShopCommodity.joins(:commodity, :shop).accessible_by(current_ability,:manage), page: params[:page], order: :left_count, order_direction: :asc)
    end
  end

  # GET /admin/shop_commodities/1
  def show
  end

  # GET /admin/shop_commodities/new
  def new
    @shop_commodity = ShopCommodity.new
  end

  # GET /admin/shop_commodities/1/edit
  def edit
  end

  def set_has_long
    shop_commodity = ShopCommodity.find(params[:id])
    shop_commodity.is_has_long = !shop_commodity.is_has_long
    shop_commodity.save
    render json: {result:"#{shop_commodity.is_has_long==true ? '是' : '否'}"}
  end

  def change_left_count
    shop_commodity = ShopCommodity.find(params[:id])
    shop_commodity.update left_count: params[:text_num].to_i
    render json: {result: 'OK'}
  end

  # POST /admin/shop_commodities
  def create
    @shop_commodity = ShopCommodity.new(shop_commodity_params)

    respond_to do |format|
      if @shop_commodity.save
        format.html { redirect_to admin_shop_commodity_path(@shop_commodity.id), notice: create_success_notice(:shop_commodity) }
       format.json { render action: 'show', status: :created, location: @shop_commodity }
      else
        format.html { render action: 'new' }
        format.json { render json: @shop_commodity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/shop_commodities/1
  def update
    respond_to do |format|
      if @shop_commodity.update_attributes(shop_commodity_params)
       format.html { redirect_to admin_shop_commodity_path(@shop_commodity.id), notice: update_success_notice(:shop_commodity) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @shop_commodity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/shop_commodities/1
  def destroy
    begin
      @shop_commodity.destroy
    rescue
      @shop_commodity.update_attributes(enable: false)
    end

    respond_to do |format|
      format.html { redirect_to admin_shop_commodities_path, notice: destroy_success_notice(:shop_commodity) }
      format.json { head :no_content }
    end
  end

  def destroy_multi
    ids =params[:grid][:select_ids]
    if ids and ids.instance_of? Array
      ids.each do |id|
        shop_commodity = ShopCommodity.find(id)
        begin
          shop_commodity.destroy! if shop_commodity
        rescue ActiveRecord::RecordNotDestroyed
          shop_commodity.update_attributes(enable: false)
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
  def set_shop_commodity
    if params[:action] == 'show'
       @shop_commodity = ShopCommodity.find(params[:id])
    else
      @shop_commodity = ShopCommodity.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def shop_commodity_params
    params.require(:shop_commodity).permit(:shop_id, :commodity_id, :price, :position, :enable, :sales_volume, :left_count, :is_has_long)
  end

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.shop_commodity.admin_title'), admin_shop_commodities_path
  end

  # add name breadcrumb with :show, :edit
  def name_breadcrumb_handler
    add_breadcrumb "商品配置", admin_shop_commodity_path(@shop_commodity.id), class: :pjax
  end
end