# coding: UTF-8
class Admin::CommunitiesController < Admin::BaseController
  load_and_authorize_resource
  before_action :base_breadcrumb
  before_action :set_community, only: [:show, :edit, :update, :destroy]
  before_action :name_breadcrumb_handler, only: [:show, :edit]
  before_action :action_common_breadcurmb, only: [:new, :edit]
  # GET /admin/communities
  def index
    @communities = initialize_grid(Community, page: params[:page], order: :created_at, order_direction: :desc)
  end

  # GET /admin/communities/1
  def show
  end

  # GET /admin/communities/new
  def new
    @community = Community.new
  end

  # GET /admin/communities/1/edit
  def edit
  end

  # POST /admin/communities
  def create
    @community = Community.new(community_params)

    respond_to do |format|
      if @community.save
        format.html { redirect_to admin_community_path(@community.id), notice: create_success_notice(:community) }
       format.json { render action: 'show', status: :created, location: @community }
      else
        format.html { render action: 'new' }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/communities/1
  def update
    respond_to do |format|
      if @community.update_attributes(community_params)
       format.html { redirect_to admin_community_path(@community.id), notice: update_success_notice(:community) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/communities/1
  def destroy
    begin
      @community.destroy
    rescue
      @community.update_attributes(enable: false)
    end

    respond_to do |format|
      format.html { redirect_to admin_communities_path, notice: destroy_success_notice(:community) }
      format.json { head :no_content }
    end
  end

  def destroy_multi
    ids =params[:grid][:select_ids]
    if ids and ids.instance_of? Array
      ids.each do |id|
        community = Community.find(id)
        begin
          community.destroy! if community
        rescue ActiveRecord::RecordNotDestroyed
          community.update_attributes(enable: false)
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
  def set_community
    if params[:action] == 'show'
       @community = Community.find(params[:id])
    else
      @community = Community.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def community_params
    params.require(:community).permit(:name, :kind, :region_id)
  end

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.community.admin_title'), admin_communities_path
  end

  # add name breadcrumb with :show, :edit
  def name_breadcrumb_handler
    add_breadcrumb @community.name, admin_community_path(@community.id), class: :pjax
  end
end