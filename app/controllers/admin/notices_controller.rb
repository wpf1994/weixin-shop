# coding: UTF-8
class Admin::NoticesController < Admin::BaseController
  before_action :base_breadcrumb
  before_action :set_notice, only: [:show, :edit, :update, :destroy]
  before_action :name_breadcrumb_handler, only: [:show, :edit]
  before_action :action_common_breadcurmb, only: [:new, :edit]
  # GET /admin/notices
  def index
    @notices = initialize_grid(Notice, page: params[:page], order: :created_at, order_direction: :desc)
  end

  # GET /admin/notices/1
  def show
  end

  # GET /admin/notices/new
  def new
    @notice = Notice.new public_at: Time.now.strftime('%F %T')
  end

  # GET /admin/notices/1/edit
  def edit
  end

  # POST /admin/notices
  def create
    @notice = Notice.new(notice_params)

    respond_to do |format|
      if @notice.save
        format.html { redirect_to admin_notice_path(@notice.id), notice: create_success_notice(:notice) }
        format.json { render action: 'show', status: :created, location: @notice }
      else
        format.html { render action: 'new' }
        format.json { render json: @notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/notices/1
  def update
    respond_to do |format|
      if @notice.update_attributes(notice_params)
        format.html { redirect_to admin_notice_path(@notice.id), notice: update_success_notice(:notice) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/notices/1
  def destroy
    begin
      @notice.destroy
    rescue
      @notice.update_attributes(enable: false)
    end

    respond_to do |format|
      format.html { redirect_to admin_notices_path, notice: destroy_success_notice(:notice) }
      format.json { head :no_content }
    end
  end

  def destroy_multi
    ids =params[:grid][:select_ids]
    if ids and ids.instance_of? Array
      ids.each do |id|
        notice = Notice.find(id)
        begin
          notice.destroy! if notice
        rescue ActiveRecord::RecordNotDestroyed
          notice.update_attributes(enable: false)
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
  def set_notice
    if params[:action] == 'show'
      @notice = Notice.find(params[:id])
    else
      @notice = Notice.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def notice_params
    params.require(:notice).permit(:title, :content, :author, :public_at)
  end

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.notice.admin_title'), admin_notices_path
  end

  # add name breadcrumb with :show, :edit
  def name_breadcrumb_handler
    add_breadcrumb @notice.title, admin_notice_path(@notice.id), class: :pjax
  end
end