# coding: UTF-8
module BreadcurmbModule
  #添加公共的导航
  def action_common_breadcurmb
    add_breadcrumb (t "common.#{params[:action]}"), nil
  end
end