# coding: UTF-8
class Admin::OrganizationsController < Admin::BaseController
  before_action :base_breadcrumb
  before_action :set_organization, only: [:show, :edit, :update, :destroy]
  before_action :name_breadcrumb_handler, only: [:show, :edit]
  before_action :action_common_breadcurmb, only: [:new, :edit]
  # GET /admin/organizations
  def index
    @organizations = initialize_grid(Organization, page: params[:page])
  end

  # GET /admin/organizations/1
  def show
  end

  # GET /admin/organizations/new
  def new
    @organization = Organization.new
  end

  # GET /admin/organizations/1/edit
  def edit
  end

  # POST /admin/organizations
  def create
    @organization = Organization.new(organization_params)

    respond_to do |format|
      if @organization.save
        format.html { redirect_to admin_organization_path(@organization.id), notice: create_success_notice(:organization) }
        format.json { render action: 'show', status: :created, location: @organization }
      else
        format.html { render action: 'new' }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/organizations/1
  def update
    respond_to do |format|
      if @organization.update_attributes(organization_params)
       format.html { redirect_to admin_organization_path(@organization.id), notice: update_success_notice(:organization) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/organizations/1
  def destroy
    begin
      @organization.destroy
    rescue
      @organization.update_attributes(enable: false)
    end

    respond_to do |format|
      format.html { redirect_to admin_organizations_path, notice: destroy_success_notice(:organization) }
      format.json { head :no_content }
    end
  end

  def destroy_multi
    ids =params[:grid][:select_ids]
    if ids and ids.instance_of? Array
      ids.each do |id|
        organization = Organization.find(id)
        begin
          organization.destroy! if organization
        rescue ActiveRecord::RecordNotDestroyed
          organization.update_attributes(enable: false)
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
  def set_organization
    if params[:action] == 'show'
       @organization = Organization.find(params[:id])
    else
      @organization = Organization.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def organization_params
    params.require(:organization).permit(:name, :parent_id, :position, :remark)
  end

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.organization.admin_title'), admin_organizations_path
  end

  # add name breadcrumb with :show, :edit
  def name_breadcrumb_handler
    add_breadcrumb @organization.name, admin_organization_path(@organization.id), class: :pjax
  end
end