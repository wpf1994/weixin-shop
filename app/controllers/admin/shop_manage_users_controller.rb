# coding: UTF-8
class Admin::ShopManageUsersController < Admin::BaseController
  before_action :base_breadcrumb
  before_action :set_shop_manage_user, only: [:show, :edit, :update, :destroy]
  before_action :name_breadcrumb_handler, only: [:show, :edit]
  before_action :action_common_breadcurmb, only: [:new, :edit]
  # GET /admin/shop_manage_users
  def index
    @shop_manage_users = initialize_grid(ShopManageUser, page: params[:page], order: :created_at, order_direction: :desc)
  end

  # GET /admin/shop_manage_users/1
  def show
  end

  # GET /admin/shop_manage_users/new
  def new
    @shop_manage_user = ShopManageUser.new
  end

  # GET /admin/shop_manage_users/1/edit
  def edit
  end

  # POST /admin/shop_manage_users
  def create
    @shop_manage_user = ShopManageUser.new(shop_manage_user_params)

    respond_to do |format|
      if @shop_manage_user.save
        #创建对应user
        user = User.create(owner: @shop_manage_user, name: "#{@shop_manage_user.name}账号", email: "#{@shop_manage_user.phone}@qq.com", phone: @shop_manage_user.phone, password: 12345678, password_confirmation: 12345678,shop_manage_id: params[:shop_owner])
        #给user添加权限
        UserRole.create({user_id: user.id, role_id: 2})
        format.html { redirect_to admin_shop_manage_user_path(@shop_manage_user.id), notice: create_success_notice(:shop_manage_user) }
       format.json { render action: 'show', status: :created, location: @shop_manage_user }
      else
        format.html { render action: 'new' }
        format.json { render json: @shop_manage_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/shop_manage_users/1
  def update
    respond_to do |format|
      if @shop_manage_user.update_attributes(shop_manage_user_params)
        @shop_manage_user.user.update shop_manage_id: params[:shop_owner]
       format.html { redirect_to admin_shop_manage_user_path(@shop_manage_user.id), notice: update_success_notice(:shop_manage_user) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @shop_manage_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/shop_manage_users/1
  def destroy
    begin
      @shop_manage_user.destroy
    rescue
      @shop_manage_user.update_attributes(enable: false)
    end

    respond_to do |format|
      format.html { redirect_to admin_shop_manage_users_path, notice: destroy_success_notice(:shop_manage_user) }
      format.json { head :no_content }
    end
  end

  def destroy_multi
    ids =params[:grid][:select_ids]
    if ids and ids.instance_of? Array
      ids.each do |id|
        shop_manage_user = ShopManageUser.find(id)
        begin
          shop_manage_user.destroy! if shop_manage_user
        rescue ActiveRecord::RecordNotDestroyed
          shop_manage_user.update_attributes(enable: false)
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
  def set_shop_manage_user
    if params[:action] == 'show'
       @shop_manage_user = ShopManageUser.find(params[:id])
    else
      @shop_manage_user = ShopManageUser.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def shop_manage_user_params
    params.require(:shop_manage_user).permit(:name, :phone)
  end

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.shop_manage_user.admin_title'), admin_shop_manage_users_path
  end

  # add name breadcrumb with :show, :edit
  def name_breadcrumb_handler
    add_breadcrumb @shop_manage_user.name, admin_shop_manage_user_path(@shop_manage_user.id), class: :pjax
  end
end