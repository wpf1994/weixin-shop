module Admin::ExpressOrdersHelper
  def express_order_edit_in_index(c)
    select= ''
    @shop.employees.each do |emp|
      select += "<option value='#{emp.user.id}'>#{emp.name}</option>"
    end
    form_str = <<-FORM
      <form action='#{admin_express_order_path(c)}' method='POST'>
        <input type="hidden" value="#{form_authenticity_token}" name="authenticity_token">
        <input name="utf8" type="hidden" value="✓">
        <input type="hidden" name="_method" value="PUT">
        <input type='text' placeholder='快点单号' data-type='eo_form' data-eo-id='#{c.id}' name="express_order[serial_number]" />
        <select data-type='eo_form' data-eo-id='#{c.id}' name="express_order[courier_id]">
          <option value="">选择送货人</option>
          #{select}
        </select>
<br>
        <div class='visible-md visible-lg hidden-sm hidden-xs btn-group'>
          <button class='btn btn-primary btn-xs' data-type='eo_form' data-eo-id='#{c.id}' type='submit' name="express_order[submit]" value="ok">提交</button>
          <button class='btn btn-warning btn-xs' data-type='eo_form' data-eo-id='#{c.id}' type='submit' name="express_order[submit]" value="not_found">未找到</button>
        </div>
      </form>
    FORM
    form_str
  end
end
