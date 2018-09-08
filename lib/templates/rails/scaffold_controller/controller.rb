<%- ns = controller_class_name.include?('::') -%># coding: UTF-8
class <%= controller_class_name %>Controller < <%= ns == true ? "#{controller_class_name.split('::').first}::" : ''  %>BaseController
  <%- if ns -%>
  before_action :base_breadcrumb
  before_action :set_<%= file_name %>, only: [:show, :edit, :update, :destroy]
  before_action :name_breadcrumb_handler, only: [:show, :edit]
  before_action :action_common_breadcurmb, only: [:new, :edit]
  <%- end -%>
  # GET <%= route_url %>
  def index
    @<%= plural_file_name %> = initialize_grid(<%= file_name.camelize %>, page: params[:page], order: :created_at, order_direction: :desc)
  end

  # GET <%= route_url %>/1
  def show
  end

  <%- if ns -%>
  # GET <%= route_url %>/new
  def new
    @<%= file_name %> = <%= orm_class.build(file_name.camelize) %>
  end

  # GET <%= route_url %>/1/edit
  def edit
  end

  # POST <%= route_url %>
  def create
    @<%= file_name %> = <%= orm_class.build(file_name.camelize, "#{file_name}_params") %>

    respond_to do |format|
      if @<%= file_name %>.save
        format.html { redirect_to <%= singular_table_name %>_path(@<%= file_name %>.id), notice: create_success_notice(:<%= file_name %>) }
       format.json { render action: 'show', status: :created, location: @<%= file_name %> }
      else
        format.html { render action: 'new' }
        format.json { render json: @<%= file_name %>.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT <%= route_url %>/1
  def update
    respond_to do |format|
      if @<%= file_name %>.update_attributes(<%= file_name %>_params)
       format.html { redirect_to <%= singular_table_name %>_path(@<%= file_name %>.id), notice: update_success_notice(:<%= file_name %>) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @<%= file_name %>.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    begin
      @<%= file_name %>.destroy
    rescue
      @<%= file_name %>.update_attributes(enable: false)
    end

    respond_to do |format|
      format.html { redirect_to <%= index_helper %>_path, notice: destroy_success_notice(:<%= file_name %>) }
      format.json { head :no_content }
    end
  end

  def destroy_multi
    ids =params[:grid][:select_ids]
    if ids and ids.instance_of? Array
      ids.each do |id|
        <%= file_name %> = <%= file_name.camelize %>.find(id)
        begin
          <%= file_name %>.destroy! if <%= file_name %>
        rescue ActiveRecord::RecordNotDestroyed
          <%= file_name %>.update_attributes(enable: false)
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
  <%- end -%>

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_<%= file_name %>
    if params[:action] == 'show'
       @<%= file_name %> = <%= orm_class.find(file_name.camelize, "params[:id]") %>
    else
      @<%= file_name %> = <%= orm_class.find(file_name.camelize, "params[:id]") %>
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def <%= "#{file_name}_params" %>
     <%- if attributes_names.empty? -%>
     params[<%= ":#{file_name}" %>]
    <%- else -%>
    params.require(<%= ":#{file_name}" %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
    <%- end -%>
  end

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.<%= file_name %>.admin_title'), <%= index_helper %>_path
  end

  # add name breadcrumb with :show, :edit
  def name_breadcrumb_handler
    add_breadcrumb @<%= file_name %>.name, <%= singular_table_name %>_path(@<%= file_name %>.id), class: :pjax
  end
end