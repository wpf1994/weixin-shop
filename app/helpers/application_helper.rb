# coding: UTF-8
module ApplicationHelper
  include NestedDataModule

  #表格的操作列
  # @param [Object] path 基础url方法的名称
  # @param [Integer] id 对应model的id
  # @param [Object] options 可选参数{do_show: true, do_edit: true, do_delete: true, pjax: true}
  def grid_operator(path, id, model,options = {})
    _options = {do_show: true, do_edit: true, do_delete: true, pjax: true}.merge(options)
    show, edit, delete = '', '', ''
     if model.nil? or can? :read, model
      show = link_to send(path, id), class: [_options[:pjax] ? :pjax : '', :btn, 'btn-xs', 'btn-success'], title: "#{t 'common.show'}" do
        raw "<i class='icon-search bigger-120'></i>"
      end if _options[:do_show]
    end
    if model.nil? or can? :update, model
    edit = link_to send("edit_#{path.to_s}", id), class: [_options[:pjax] ? :pjax : '', :btn, 'btn-xs', 'btn-info'], title: "#{t 'common.edit'}" do
      raw "<i class='icon-edit bigger-120'></i>"
    end if _options[:do_edit]
    end
    if model.nil? or can? :delete, model
      delete = link_to send(path, id), method: :delete, title: "#{t 'common.delete'}", class: [:btn, 'btn-xs', 'btn-danger'], data: { confirm: "#{t 'common.confirm_delete'}" } do
      raw "<i class='icon-trash bigger-120'></i>"
    end if _options[:do_delete]
    end
    return raw("<div class='visible-md visible-lg hidden-sm hidden-xs btn-group'>#{show} #{edit} #{delete}</div>")
  end

  #上下级结构显示
  def nested_show_for_select(class_or_item, mover = nil, from_self = false, with_self = true)
    nested_set_options_ts(class_or_item, mover, from_self, with_self) {|i| "#{'-' * i.level} #{i.name}" }
  end


  #显示为金额
  def to_money(value)
    number_to_currency(value, :unit => '¥')
  end

  #处理日期选择(从今天开始)
  def date_picker_from_today(dom_setting, setting = {})
    date_picker_handler(dom_setting, {minDate:'%y-%M-%d'}.merge(setting))
  end

  #获取日期控件的配置
  def date_picker_handler(dom_setting, setting = {})
    dom_setting[:readonly] = :readonly
    _setting = {isShowClear:false, readOnly:true, firstDayOfWeek:1}.merge(setting)
    dom_setting[:onFocus] = "WdatePicker(#{_setting.to_json})"
    dom_setting
  end

  #处理日期时间选择
  def datetime_picker_handler(dom_setting, setting = {})
    dom_setting[:readonly] = :readonly
    _setting = {isShowClear:false, readOnly:true, firstDayOfWeek:1, dateFmt: 'yyyy-MM-dd HH:mm:ss'}.merge(setting)
    dom_setting[:onFocus] = "WdatePicker(#{_setting.to_json})"
    dom_setting
  end

  #处理时间时间选择
  def time_picker_handler(dom_setting, setting = {})
    dom_setting[:readonly] = :readonly
    _setting = {isShowClear:false, readOnly:true, firstDayOfWeek:1, dateFmt: 'HH:mm:ss'}.merge(setting)
    dom_setting[:onFocus] = "WdatePicker(#{_setting.to_json})"
    dom_setting
  end
end
