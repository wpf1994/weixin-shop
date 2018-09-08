# coding: UTF-8
class Admin::CodeTablesController < Admin::BaseController
  load_and_authorize_resource
  before_action :base_breadcrumb
  before_action :set_code_table, only: [:show, :edit, :update, :destroy]
  before_action :name_breadcrumb_handler, only: [:show, :edit]
  before_action :action_common_breadcurmb, only: [:new, :edit]
  # GET /admin/code_tables
  def index
    @code_tables = initialize_grid(CodeTable, page: params[:page])
  end

  # GET /admin/code_tables/1
  def show
  end

  # GET /admin/code_tables/new
  def new
    @code_table = CodeTable.new
  end

  # GET /admin/code_tables/1/edit
  def edit
  end

  # POST /admin/code_tables
  def create
    @code_table = CodeTable.new(code_table_params)

    respond_to do |format|
      if @code_table.save
        format.html { redirect_to admin_code_table_path(@code_table.id), notice: create_success_notice(:code_table) }
        format.json { render action: 'show', status: :created, location: @code_table }
      else
        format.html { render action: 'new' }
        format.json { render json: @code_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/code_tables/1
  def update
    respond_to do |format|
      if @code_table.update_attributes(code_table_params)
        format.html { redirect_to admin_code_table_path(@code_table.id), notice: update_success_notice(:code_table) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @code_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/code_tables/1
  def destroy
    begin
      @code_table.destroy
    rescue
      @code_table.update_attributes(enable: false)
    end

    respond_to do |format|
      format.html { redirect_to admin_code_tables_path, notice: destroy_success_notice(:code_table) }
      format.json { head :no_content }
    end
  end

  def destroy_multi
    ids =params[:grid][:select_ids]
    if ids and ids.instance_of? Array
      ids.each do |id|
        code_table = CodeTable.find(id)
        begin
          code_table.destroy! if code_table
        rescue ActiveRecord::RecordNotDestroyed
          code_table.update_attributes(enable: false)
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
  def set_code_table
    if params[:action] == 'show'
      @code_table = CodeTable.find(params[:id])
    else
      @code_table = CodeTable.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def code_table_params
    params.require(:code_table).permit(:name, :parent_id, :position, :remark, :default_value)
  end

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.code_table.admin_title'), admin_code_tables_path
  end

  # add name breadcrumb with :show, :edit
  def name_breadcrumb_handler
    add_breadcrumb @code_table.name, admin_code_table_path(@code_table.id), class: :pjax
  end
end