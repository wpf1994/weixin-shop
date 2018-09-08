# coding: UTF-8
class Admin::RolesController < Admin::BaseController
  load_and_authorize_resource
  before_action :base_breadcrumb
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  before_action :name_breadcrumb_handler, only: [:show, :edit]
  before_action :action_common_breadcurmb, only: [:new, :edit]
  # GET /admin/roles
  def index
    @roles = initialize_grid(Role, order: 'position',
                             order_direction: :asc, page: params[:page])
  end

  # GET /admin/roles/1
  def show
    @permissions = Permission.select('permissions.*, code_tables.name AS group_name')
                       .joins(:group, :role_permissions)
                       .where('role_permissions.role_id = ?', @role.id)
  end

  # GET /admin/roles/new
  def new
    @role = Role.new
  end

  # GET /admin/roles/1/edit
  def edit
  end

  #获取对应的属性结构
  def tree_data
    case params[:type]
      when 'permissions'
        #获取权限
        @tree_data = []
        @tree_data += CodeTable.get_children(CodeTable.ids[:role][:group][:id])
        @tree_data += Permission.all
        if params[:role_id].present?
          role = Role.find(params[:role_id])
          if role.present?
            @selected = role.permissions
          end
        end
        render 'common/tree_permissions'
      when 'roles'
        #获取人员的所有角色tree
        @tree_data = []
        @tree_data += Role.all
        if params[:user_id].present?
          user = User.find(params[:user_id])
          if user.present?
            @selected = user.roles
          end
        end
        render 'common/tree_roles'
    end
  end

  # POST /admin/roles
  def create
    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        format.html { redirect_to admin_role_path(@role.id), notice: create_success_notice(:role) }
        format.json { render action: 'show', status: :created, location: @role }
      else
        format.html { render action: 'new' }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/roles/1
  def update
    @role.permissions.destroy_all
    respond_to do |format|
      if @role.update_attributes(role_params)
        format.html { redirect_to admin_role_path(@role.id), notice: update_success_notice(:role) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/roles/1
  def destroy
    begin
      @role.destroy
    rescue
      @role.update_attributes(enable: false)
    end

    respond_to do |format|
      format.html { redirect_to admin_roles_path, notice: destroy_success_notice(:role) }
      format.json { head :no_content }
    end
  end

  def destroy_multi
    ids =params[:grid][:select_ids]
    if ids and ids.instance_of? Array
      ids.each do |id|
        role = Role.find(id)
        begin
          role.destroy! if role
        rescue ActiveRecord::RecordNotDestroyed
          role.update_attributes(enable: false)
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
  def set_role
    if params[:action] == 'show'
      @role = Role.find(params[:id])
    else
      @role = Role.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def role_params
    params.require(:role).permit(:name, :description, :position, role_permissions_attributes: [:permission_id])
  end

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.role.admin_title'), admin_roles_path
  end

  # add name breadcrumb with :show, :edit
  def name_breadcrumb_handler
    add_breadcrumb @role.name, admin_role_path(@role.id), class: :pjax
  end
end