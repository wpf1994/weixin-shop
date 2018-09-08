# coding: UTF-8
class Admin::ClassificationsController < Admin::BaseController
  load_and_authorize_resource
  before_action :base_breadcrumb
  before_action :set_classification, only: [:show, :edit, :update, :destroy]
  before_action :name_breadcrumb_handler, only: [:show, :edit]
  before_action :action_common_breadcurmb, only: [:new, :edit]
  # GET /admin/classifications
  def index
    @classifications = initialize_grid(Classification, page: params[:page], order: :created_at, order_direction: :desc)
  end

  # GET /admin/classifications/1
  def show
  end

  # GET /admin/classifications/new
  def new
    @classification = Classification.new
  end

  # GET /admin/classifications/1/edit
  def edit
  end

  # POST /admin/classifications
  def create
    @classification = Classification.new(classification_params)

    respond_to do |format|
      if @classification.save
        format.html { redirect_to admin_classification_path(@classification.id), notice: create_success_notice(:classification) }
       format.json { render action: 'show', status: :created, location: @classification }
      else
        format.html { render action: 'new' }
        format.json { render json: @classification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/classifications/1
  def update
    respond_to do |format|
      if @classification.update_attributes(classification_params)
       format.html { redirect_to admin_classification_path(@classification.id), notice: update_success_notice(:classification) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @classification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/classifications/1
  def destroy
    begin
      @classification.destroy
    rescue
      @classification.update_attributes(enable: false)
    end

    respond_to do |format|
      format.html { redirect_to admin_classifications_path, notice: destroy_success_notice(:classification) }
      format.json { head :no_content }
    end
  end

  def destroy_multi
    ids =params[:grid][:select_ids]
    if ids and ids.instance_of? Array
      ids.each do |id|
        classification = Classification.find(id)
        begin
          classification.destroy! if classification
        rescue ActiveRecord::RecordNotDestroyed
          classification.update_attributes(enable: false)
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
  def set_classification
    if params[:action] == 'show'
       @classification = Classification.find(params[:id])
    else
      @classification = Classification.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def classification_params
    params.require(:classification).permit(:name, :parent_id, :position,:single_statistics)
  end

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.classification.admin_title'), admin_classifications_path
  end

  # add name breadcrumb with :show, :edit
  def name_breadcrumb_handler
    add_breadcrumb @classification.name, admin_classification_path(@classification.id), class: :pjax
  end
end