# coding: UTF-8
class Admin::EmployeesController < Admin::BaseController
  load_and_authorize_resource
  before_action :base_breadcrumb
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  before_action :name_breadcrumb_handler, only: [:show, :edit]
  before_action :action_common_breadcurmb, only: [:new, :edit]
  # GET /admin/employees
  def index
    @employees = initialize_grid(Employee, page: params[:page], order: :created_at, order_direction: :desc)
  end

  # GET /admin/employees/1
  def show
  end

  # GET /admin/employees/new
  def new
    @employee = Employee.new
  end

  # GET /admin/employees/1/edit
  def edit
  end

  # POST /admin/employees
  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        user = User.create(owner: @employee, email: "#{@employee.phone}@qq.com", name: "#{@employee.name}", phone: @employee.phone, password: 12345678, password_confirmation: 12345678)
        user.save
        format.html { redirect_to admin_employee_path(@employee.id), notice: create_success_notice(:employee) }
       format.json { render action: 'show', status: :created, location: @employee }
      else
        format.html { render action: 'new' }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/employees/1
  def update
    respond_to do |format|
      if @employee.update_attributes(employee_params)
       format.html { redirect_to admin_employee_path(@employee.id), notice: update_success_notice(:employee) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/employees/1
  def destroy
    begin
      @employee.destroy
    rescue
      @employee.update_attributes(enable: false)
    end

    respond_to do |format|
      format.html { redirect_to admin_employees_path, notice: destroy_success_notice(:employee) }
      format.json { head :no_content }
    end
  end

  def destroy_multi
    ids =params[:grid][:select_ids]
    if ids and ids.instance_of? Array
      ids.each do |id|
        employee = Employee.find(id)
        begin
          employee.destroy! if employee
        rescue ActiveRecord::RecordNotDestroyed
          employee.update_attributes(enable: false)
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
  def set_employee
    if params[:action] == 'show'
       @employee = Employee.find(params[:id])
    else
      @employee = Employee.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def employee_params
    params.require(:employee).permit(:name, :phone, :photo, :shop_id)
  end

  def base_breadcrumb
    add_breadcrumb (t 'activerecord.attributes.employee.admin_title'), admin_employees_path
  end

  # add name breadcrumb with :show, :edit
  def name_breadcrumb_handler
    add_breadcrumb @employee.name, admin_employee_path(@employee.id), class: :pjax
  end
end