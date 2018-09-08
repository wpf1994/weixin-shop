# coding: UTF-8
class Admin::PermissionsController < Admin::BaseController
  before_action :base_breadcrumb
  before_action :set_permission, only: [:show, :edit, :update, :destroy]
  before_action :name_breadcrumb_handler, only: [:show, :edit]
  before_action :action_common_breadcurmb, only: [:new, :edit]
  # GET /admin/permissions
  def index
    @permissions = initialize_grid(Permission, page: params[:page], order: :created_at, order_direction: :desc)
  end

  # GET /admin/permissions/1
  def show
  end

  # GET /admin/permissions/new
  def new
    @permission = Permission.new
  end

  # GET /admin/permissions/1/edit
  def edit
  end

  # POST /admin/permissions
  def create
    @permission = Permission.new(permission_params)

    respond_to do |format|
      if @permission.save
        format.html { redirect_to admin_permission_path(@permission.id), notice: create_success_notice(:permission) }
       format.json { render action: 'show', status: :created, location: @permission }
      else
        format.html { render action: 'new' }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/permissions/1
  def update
    respond_to do |format|
      if @permission.update_attributes(permission_params)
       format.html { redirect_to admin_permission_path(@permission.id), notice: update_success_notice(:permission) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/permissions/1
  def destroy
    begin
      @permission.destroy
    rescue
      @permission.update_attributes(enable: false)
    end

    respond_to do |format|
      format.html { redirect_to admin_permissions_path, notice: destroy_success_notice(:permission) }
      format.json { head :no_content }
    end
  end

  def destroy_multi
    ids =params[:grid][:select_ids]
    if ids and ids.instance_of? Array
      ids.each do |id|
        permission = Permission.find(id)
        begin
          permission.destroy! if permission
        rescue ActiveRecord::RecordNotDestroyed
          permission.update_attributes(enable: false)
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
  def set_permission
    if params[:action] == 'show'
       @permission = Permission.find(params[:id])
    else
      @permission = Permission.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def permission_params
    params.require(:permission).permit(:action, :subject, :description, :code, :group_id, :fetching)
  end

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.permission.admin_title'), admin_permissions_path
  end

  # add name breadcrumb with :show, :edit
  def name_breadcrumb_handler
    add_breadcrumb @permission.description, admin_permission_path(@permission.id), class: :pjax
  end
end