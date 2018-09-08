$ = jQuery

$selector = null
_setting =
  selected_multi: true#多选
  tmpl_name: 'templates/common_selector' #模板文件名称
  title: '请选择联系人'

#判断节点是否可以选择
phone_OPERATOR = /// ^ (1\d{10}) ///
node_can_select = (event, treeId, treeNode)->
  treeNode && treeNode.type == 'contact' && phone_OPERATOR.exec(treeNode.phone)

addDiyDom = (treeId, treeNode) ->
  if treeNode.type == 'contacts_group'
    if $("#all_select_btn_"+treeNode.id).length > 0
      return;
    aObj = $("##{treeNode.tId}_a");
    editStr = "&nbsp;<span class='label label-info' style='padding: 1px 4px 0' id='all_select_btn#{treeNode.id}' title='全选' onfocus='this.blur();'><i class='fa fa-mail-forward'></i></span>";
    aObj.append(editStr);
    btn = $("#all_select_btn#{treeNode.id}");
    if btn
      btn.click ->
        $selector.add_node_to_select($.fn.zTree.getZTreeObj(treeId).getNodesByParam('type', 'contact', treeNode))

#ztree的配置
ztree_setting =
  view:
    addDiyDom: addDiyDom
  data:
    simpleData:
      enable: true

$.fn.contacts_selector =
  init: (setting = {}, tree_setting = {}) ->
    _options = $.extend({}, _setting, setting)
    $selector = $.fn.common_selector.init($("<div id='contacts_#{Math.floor(Math.random()*1000)}'></div>").appendTo($('body')), _options)
    handle_option = {can_select: node_can_select}
    $selector.add_tree('联系人选择', $.extend(true, {}, ztree_setting, tree_setting), $.fn.commom.contacts_tree.node_data(), handle_option)
#    $selector.add_tree('角色选择', ztree_setting, $.fn.commom.role_contacts_tree.node_data(), handle_option)
    $selector