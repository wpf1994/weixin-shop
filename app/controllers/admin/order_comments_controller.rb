# coding: UTF-8
class Admin::OrderCommentsController < Admin::BaseController
  load_and_authorize_resource
  before_action :base_breadcrumb
  before_action :set_order_comment, only: [:show, :edit, :update, :destroy]
  before_action :name_breadcrumb_handler, only: [:show, :edit]
  before_action :action_common_breadcurmb, only: [:new, :edit]
  # GET /admin/order_comments
  def index
    @order_comments = initialize_grid(OrderComment, page: params[:page], order: :created_at, order_direction: :desc)
  end

  # GET /admin/order_comments/1
  def show
  end

  # GET /admin/order_comments/new
  def new
    @order_comment = OrderComment.new
  end

  # GET /admin/order_comments/1/edit
  def edit
  end

  # POST /admin/order_comments
  def create
    @order_comment = OrderComment.new(order_comment_params)

    respond_to do |format|
      if @order_comment.save
        format.html { redirect_to admin_order_comment_path(@order_comment.id), notice: create_success_notice(:order_comment) }
       format.json { render action: 'show', status: :created, location: @order_comment }
      else
        format.html { render action: 'new' }
        format.json { render json: @order_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/order_comments/1
  def update
    respond_to do |format|
      if @order_comment.update_attributes(order_comment_params)
       format.html { redirect_to admin_order_comment_path(@order_comment.id), notice: update_success_notice(:order_comment) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/order_comments/1
  def destroy
    begin
      @order_comment.destroy
    rescue
      @order_comment.update_attributes(enable: false)
    end

    respond_to do |format|
      format.html { redirect_to admin_order_comments_path, notice: destroy_success_notice(:order_comment) }
      format.json { head :no_content }
    end
  end

  def destroy_multi
    ids =params[:grid][:select_ids]
    if ids and ids.instance_of? Array
      ids.each do |id|
        order_comment = OrderComment.find(id)
        begin
          order_comment.destroy! if order_comment
        rescue ActiveRecord::RecordNotDestroyed
          order_comment.update_attributes(enable: false)
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
  def set_order_comment
    if params[:action] == 'show'
       @order_comment = OrderComment.find(params[:id])
    else
      @order_comment = OrderComment.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_comment_params
    params.require(:order_comment).permit(:order_id, :shop_id, :total_star, :speed_star, :server_start, :content)
  end

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.order_comment.admin_title'), admin_order_comments_path
  end

  # add name breadcrumb with :show, :edit
  def name_breadcrumb_handler
    add_breadcrumb "订单评价详情", admin_order_comment_path(@order_comment.id), class: :pjax
  end
end