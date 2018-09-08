# coding: UTF-8
class Admin::AttachmentsController < Admin::BaseController

  before_action :base_breadcrumb
  before_action :set_attachment, only: [:show, :edit, :update, :destroy]
  before_action :name_breadcrumb_handler, only: [:show, :edit]
  before_action :action_common_breadcurmb, only: [:new, :edit]

  # GET /admin/attachments
  def index
    @attachments = initialize_grid(Attachment, page: params[:page], order: :created_at, order_direction: :desc)
  end

  # GET /admin/attachments/1
  def show
  end


  # GET /admin/attachments/new
  def new
    @attachment = Attachment.new
  end

  # GET /admin/attachments/1/edit
  def edit
  end

  # POST /admin/attachments
  def create
    @attachment = Attachment.new(attachment_params)
    @attachment.author_id = current_user.id

    respond_to do |format|
      if @attachment.save
        format.html { redirect_to admin_attachment_path(@attachment.id), notice: create_success_notice(:attachment) }
       format.json { render action: 'show', status: :created, location: @attachment }
      else
        format.html { render action: 'new' }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/attachments/1
  def update
    respond_to do |format|
      if @attachment.update_attributes(attachment_params)
       format.html { redirect_to admin_attachment_path(@attachment.id), notice: update_success_notice(:attachment) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/attachments/1
  def destroy
    begin
      @attachment.destroy
    rescue
      @attachment.update_attributes(enable: false)
    end

    respond_to do |format|
      format.html { redirect_to admin_attachments_path, notice: destroy_success_notice(:attachment) }
      format.json { head :no_content }
    end
  end

  def destroy_multi
    ids =params[:grid][:select_ids]
    if ids and ids.instance_of? Array
      ids.each do |id|
        attachment = Attachment.find(id)
        begin
          attachment.destroy! if attachment
        rescue ActiveRecord::RecordNotDestroyed
          attachment.update_attributes(enable: false)
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
  def set_attachment
    if params[:action] == 'show'
       @attachment = Attachment.find(params[:id])
    else
      @attachment = Attachment.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def attachment_params

    params.require(:attachment).permit(:name, :avatar, :author_id, :position, :date_type)

  end

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.attachment.admin_title'), admin_attachments_path
  end

  # add name breadcrumb with :show, :edit
  def name_breadcrumb_handler
    add_breadcrumb @attachment.name, admin_attachment_path(@attachment.id), class: :pjax
  end
end