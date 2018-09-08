# coding: UTF-8
class Admin::AdvertsController < Admin::BaseController
  before_action :base_breadcrumb
  before_action :set_advert, only: [:show, :edit, :update, :destroy]
  before_action :name_breadcrumb_handler, only: [:show, :edit]
  before_action :action_common_breadcurmb, only: [:new, :edit]
  # GET /admin/adverts
  def index
    @adverts = initialize_grid(Advert, page: params[:page], order: :created_at, order_direction: :desc)
  end

  # GET /admin/adverts/1
  def show
  end

  # GET /admin/adverts/new
  def new
    @advert = Advert.new
  end

  # GET /admin/adverts/1/edit
  def edit
  end

  # POST /admin/adverts
  def create
    @advert = Advert.new(advert_params)

    respond_to do |format|
      if @advert.save
        format.html { redirect_to admin_advert_path(@advert.id), notice: create_success_notice(:advert) }
       format.json { render action: 'show', status: :created, location: @advert }
      else
        format.html { render action: 'new' }
        format.json { render json: @advert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/adverts/1
  def update
    respond_to do |format|
      if @advert.update_attributes(advert_params)
       format.html { redirect_to admin_advert_path(@advert.id), notice: update_success_notice(:advert) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @advert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/adverts/1
  def destroy
    begin
      @advert.destroy
    rescue
      @advert.update_attributes(enable: false)
    end

    respond_to do |format|
      format.html { redirect_to admin_adverts_path, notice: destroy_success_notice(:advert) }
      format.json { head :no_content }
    end
  end

  def destroy_multi
    ids =params[:grid][:select_ids]
    if ids and ids.instance_of? Array
      ids.each do |id|
        advert = Advert.find(id)
        begin
          advert.destroy! if advert
        rescue ActiveRecord::RecordNotDestroyed
          advert.update_attributes(enable: false)
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
  def set_advert
    if params[:action] == 'show'
       @advert = Advert.find(params[:id])
    else
      @advert = Advert.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def advert_params
    params.require(:advert).permit(:name, :title, :link, :cover)
  end

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.advert.admin_title'), admin_adverts_path
  end

  # add name breadcrumb with :show, :edit
  def name_breadcrumb_handler
    add_breadcrumb @advert.name, admin_advert_path(@advert.id), class: :pjax
  end
end