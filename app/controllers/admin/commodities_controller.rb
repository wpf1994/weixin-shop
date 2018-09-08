# coding: UTF-8
class Admin::CommoditiesController < Admin::BaseController
  load_and_authorize_resource
  before_action :base_breadcrumb
  before_action :set_commodity, only: [:show, :edit, :update, :destroy]
  before_action :name_breadcrumb_handler, only: [:show, :edit]
  before_action :action_common_breadcurmb, only: [:new, :edit]
  # GET /admin/commodities
  def index
    @commodities = initialize_grid(Commodity, page: params[:page], order: :created_at, order_direction: :desc)
  end

  # GET /admin/commodities/1
  def show
  end

  # GET /admin/commodities/new
  def new
    @commodity = Commodity.new
  end

  # GET /admin/commodities/1/edit
  def edit
  end

  # POST /admin/commodities
  def create
    @commodity = Commodity.new(commodity_params)

    respond_to do |format|
      if @commodity.save
        format.html { redirect_to admin_commodity_path(@commodity.id), notice: create_success_notice(:commodity) }
       format.json { render action: 'show', status: :created, location: @commodity }
      else
        format.html { render action: 'new' }
        format.json { render json: @commodity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/commodities/1
  def update
    respond_to do |format|
      old_price = @commodity.reference_price
      if @commodity.update_attributes(commodity_params)
        if(@commodity.reference_price != old_price)
          #价格修改过
          #修改所有商店配置价格相同的配置
          ShopCommodity.where(commodity_id: @commodity.id, price: old_price).update_all({price: @commodity.reference_price})
        end
       format.html { redirect_to admin_commodity_path(@commodity.id), notice: update_success_notice(:commodity) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @commodity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/commodities/1
  def destroy
    begin
      @commodity.destroy
    rescue
      @commodity.update_attributes(enable: false)
    end

    respond_to do |format|
      format.html { redirect_to admin_commodities_path, notice: destroy_success_notice(:commodity) }
      format.json { head :no_content }
    end
  end

  def destroy_multi
    ids =params[:grid][:select_ids]
    if ids and ids.instance_of? Array
      ids.each do |id|
        commodity = Commodity.find(id)
        begin
          commodity.destroy! if commodity
        rescue ActiveRecord::RecordNotDestroyed
          commodity.update_attributes(enable: false)
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

  def upload
    if(request.method.to_s.downcase == 'post')
      #进行文件上传
      filename = params[:file].original_filename
      #去除扩展名
      filename = filename[0...(filename.rindex('.'))]
      #拆分字符串
      strs = filename.split('-')
      if(strs.length != 3)
        render json: {error: '文件名称错误,分类名-商品名-价格'}, status: 400
        return
      end
      if(strs[2].to_f == 0)
        render json: {error: '价格格式错误'}, status: 400
        return
      end
      #查询或新增分类
      classification = Classification.find_or_create_by(name: strs[0])
      #查询商品
      commodity = Commodity.where(name: strs[1]).first_or_create do |commodity|
        commodity.name = strs[1]
        commodity.reference_price = strs[2]
      end
      #修改商品
      commodity.summary = strs[1]
      commodity.content = strs[1]
      commodity.reference_price = strs[2]
      commodity.classification_id = classification.id

      attachment = Attachment.new
      ex_name = params[:file].original_filename[(params[:file].original_filename.rindex('.')).. -1]
      params[:file].original_filename = "#{rand * Time.now.to_i}".sub('.', '')
      params[:file].original_filename += ex_name
      attachment.avatar = params[:file]
      attachment.save

      commodity.cover = attachment
      commodity.save

      render json: '上传成功', status: 200
      return
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_commodity
    if params[:action] == 'show'
       @commodity = Commodity.find(params[:id])
    else
      @commodity = Commodity.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def commodity_params
    params.require(:commodity).permit(:name, :summary, :content, :identifier, :reference_price, :classification_id, cover_attributes: [:avatar, :id, :_destroy])
  end

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.commodity.admin_title'), admin_commodities_path
  end

  # add name breadcrumb with :show, :edit
  def name_breadcrumb_handler
    add_breadcrumb @commodity.name, admin_commodity_path(@commodity.id), class: :pjax
  end
end