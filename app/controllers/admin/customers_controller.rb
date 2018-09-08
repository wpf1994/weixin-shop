# coding: UTF-8
class Admin::CustomersController < Admin::BaseController
  load_and_authorize_resource
  before_action :base_breadcrumb
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  before_action :name_breadcrumb_handler, only: [:show, :edit]
  before_action :action_common_breadcurmb, only: [:new, :edit]
  # GET /admin/customers
  def index
    @customers = initialize_grid(Customer, page: params[:page], order: :created_at, order_direction: :desc)
  end

  # GET /admin/customers/1
  def show
  end

  # GET /admin/customers/new
  def new
    @customer = Customer.new
  end

  # GET /admin/customers/1/edit
  def edit
  end

  # POST /admin/customers
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to admin_customer_path(@customer.id), notice: create_success_notice(:customer) }
       format.json { render action: 'show', status: :created, location: @customer }
      else
        format.html { render action: 'new' }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/customers/1
  def update
    respond_to do |format|
      if @customer.update_attributes(customer_params)
       format.html { redirect_to admin_customer_path(@customer.id), notice: update_success_notice(:customer) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/customers/1
  def destroy
    begin
      @customer.destroy
    rescue
      @customer.update_attributes(enable: false)
    end

    respond_to do |format|
      format.html { redirect_to admin_customers_path, notice: destroy_success_notice(:customer) }
      format.json { head :no_content }
    end
  end

  def destroy_multi
    ids =params[:grid][:select_ids]
    if ids and ids.instance_of? Array
      ids.each do |id|
        customer = Customer.find(id)
        begin
          customer.destroy! if customer
        rescue ActiveRecord::RecordNotDestroyed
          customer.update_attributes(enable: false)
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
  def set_customer
    if params[:action] == 'show'
       @customer = Customer.find(params[:id])
    else
      @customer = Customer.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def customer_params
    params.require(:customer).permit(:name, :member_number, :phone, :email, :score, :weixin_id, :lase_shop_id)
  end

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.customer.admin_title'), admin_customers_path
  end

  # add name breadcrumb with :show, :edit
  def name_breadcrumb_handler
    add_breadcrumb @customer.name, admin_customer_path(@customer.id), class: :pjax
  end
end