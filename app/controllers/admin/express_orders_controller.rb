# coding: UTF-8
class Admin::ExpressOrdersController < Admin::BaseController
  before_action :base_breadcrumb
  before_action :set_express_order, only: [:show, :edit, :update, :destroy]
  before_action :name_breadcrumb_handler, only: [:show, :edit]
  before_action :action_common_breadcurmb, only: [:new, :edit]
  # GET /admin/express_orders
  def index
    # express_orders = ExpressOrder.all.accessible_by(current_ability)
    @shop = current_user.manage_shop
    @express_orders = initialize_grid(@shop.express_orders.joins("LEFT JOIN users on users.id=express_orders.courier_id"), page: params[:page], order: :created_at, order_direction: :desc)
  end

  # GET /admin/express_orders/1
  def show
  end


  #读取未送货数量
  def read_express_count
    @shop = current_user.manage_shop
    count = @shop.express_orders.joins("LEFT JOIN users on users.id=express_orders.courier_id").where('express_orders.status=0').count
    render json: count
  end

  # GET /admin/express_orders/new
  def new
    @express_order = ExpressOrder.new
  end

  # GET /admin/express_orders/1/edit
  def edit
  end

  # POST /admin/express_orders
  def create
    @express_order = ExpressOrder.new(express_order_params)

    respond_to do |format|
      if @express_order.save
        format.html { redirect_to admin_express_order_path(@express_order.id), notice: create_success_notice(:express_order) }
        format.json { render action: 'show', status: :created, location: @express_order }
      else
        format.html { render action: 'new' }
        format.json { render json: @express_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/express_orders/1
  def update
    respond_to do |format|
      case params[:express_order][:submit]
        when 'ok'
          updated = @express_order.update_attributes(serial_number: params[:express_order][:serial_number], courier_id: params[:express_order][:courier_id],
                                                     completed_at: Time.now, status: 1)
        when 'not_found'
          updated = @express_order.update_attributes status: -1
      end

      if updated
        format.html { redirect_to :back }
        format.json { head :no_content }
      else
        format.html { render :back }
        format.json { render json: @express_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/express_orders/1
  def destroy
    begin
      @express_order.destroy
    rescue
      @express_order.update_attributes(enable: false)
    end

    respond_to do |format|
      format.html { redirect_to admin_express_orders_path, notice: destroy_success_notice(:express_order) }
      format.json { head :no_content }
    end
  end

  def destroy_multi
    ids =params[:grid][:select_ids]
    if ids and ids.instance_of? Array
      ids.each do |id|
        express_order = ExpressOrder.find(id)
        begin
          express_order.destroy! if express_order
        rescue ActiveRecord::RecordNotDestroyed
          express_order.update_attributes(enable: false)
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
  def set_express_order
    if params[:action] == 'show'
      @express_order =
          express_orders = ExpressOrder.all.accessible_by(current_ability).find_by_id(params[:id])
    else
      @express_order =
          express_orders = ExpressOrder.all.accessible_by(current_ability).find_by_id(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def express_order_params
    params.require(:express_order).permit(:consignee, :phone, :address, :status, :shop_id, :courier_id, :serial_number, :completed_at, :submit)
  end

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.express_order.admin_title'), admin_express_orders_path
  end

  # add name breadcrumb with :show, :edit
  def name_breadcrumb_handler
    add_breadcrumb @express_order.consignee, admin_express_order_path(@express_order.id), class: :pjax
  end
end