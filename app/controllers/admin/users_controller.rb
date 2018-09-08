# coding: UTF-8
class Admin::UsersController < Admin::BaseController
  load_and_authorize_resource
  before_action :base_breadcrumb
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :name_breadcrumb_handler, only: [:show, :edit]
  before_action :action_common_breadcurmb, only: [:new, :edit]
  # GET /admin/users
  def index
    @users = initialize_grid(User, page: params[:page])
  end

  #获取树形结构数据
  #只显示自己单位和下级单位的数据
  def tree_data
    case params[:type]
      when 'odp'
        #加载组织机构和人员
        @tree_data = []
        orgs = present_and_sort(Organization.find(current_user.organization_id).self_and_descendants)
        deps = Department.select('departments.*, people.organization_id AS organization_id')
                   .joins(:people).where('people.organization_id IN (?)', orgs).order(position: :asc).distinct
        @tree_data += orgs
        @tree_data += deps
        @tree_data += Person.where(organization_id: orgs).order(position: :asc)
        render 'common/tree'
      when 'rp'
        #根据角色加载人员
        @tree_data = []
        orgs = present_and_sort(Organization.find(current_user.organization_id).self_and_descendants)
        #查询自己最高的角色
        top_role = PersonRole.select('roles.position AS position').joins(:role).where(user_id: current_user.id).order('roles.position ASC').first
        @tree_data += Role.where('position >= ?', top_role.position)
        @tree_data += PersonRole.select('people.*, roles.id AS role_id').joins(:user, :role)
                          .where('people.organization_id IN (?) AND roles.position >= ?', orgs, top_role.position)
        render 'common/role_people_tree'
    end
  end

  # GET /admin/users/1
  def show
  end

  # GET /admin/users/new
  def new
    @user = User.new
  end

  # GET /admin/users/1/edit
  def edit
  end

  def validate_user
    count = 0
    if params[:id]
      count = User.where("#{params[:field]} = ? AND id <> ?", params[:value], params[:id]).count
    else
      count = User.where("#{params[:field]} = ?", params[:value]).count
    end
    if count > 0
      render json: {value: params[:value], valid: 0, message: '此数据不可使用'}
    else
      render json: {value: params[:value], valid: 1, message: '此数据可以使用'}
    end
  end

  # POST /admin/users
  def create
    u_params = user_params
    if u_params[:password].blank?
      u_params[:password] = u_params[:phone]
      u_params[:password_confirmation] = u_params[:phone]
    else
      u_params[:password_confirmation] = u_params[:password]
    end
    @user = User.new(u_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_user_path(@user.id), notice: create_success_notice(:user) }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_password
    if request.get?
      render layout: 'application'
    else
      @user = User.find(current_user.id)
      respond_to do |format|
        if @user.update_with_password(password_params)
          sign_in @user, bypass: true
          format.html { redirect_to root_path, notice: (t 'login.change_password_success') }
          format.json { render action: 'update_password', status: :created }
        else
          format.html { redirect_to update_password_admin_people_path }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /admin/users/1
  def update
    u_params = user_params
    if u_params[:password].blank?
      u_params.delete(:password)
    else
      u_params[:password_confirmation] = u_params[:password]
    end
    @user.roles.destroy_all

    respond_to do |format|
      if @user.update_attributes(u_params)
        format.html { redirect_to admin_user_path(@user.id), notice: update_success_notice(:user) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/users/1
  def destroy
    begin
      @user.destroy
    rescue
      @user.update_attributes(enable: false)
    end

    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: destroy_success_notice(:user) }
      format.json { head :no_content }
    end
  end

  def destroy_multi
    ids =params[:grid][:select_ids]
    if ids and ids.instance_of? Array
      ids.each do |id|
        user = User.find(id)
        begin
          user.destroy! if user
        rescue ActiveRecord::RecordNotDestroyed
          user.update_attributes(enable: false)
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
  def set_user
    if params[:action] == 'show'
      @user = User.find(params[:id])
    else
      @user = User.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :phone, :organization_id, :remark,
                                 user_roles_attributes: [:role_id],
    )
  end

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.user.admin_title'), admin_users_path
  end

  # add name breadcrumb with :show, :edit
  def name_breadcrumb_handler
    add_breadcrumb @user.name, admin_user_path(@user.id), class: :pjax
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end