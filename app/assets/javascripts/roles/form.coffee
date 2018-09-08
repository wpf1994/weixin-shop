$ ->
  $permissions_div = $('#permissions_div')
  _permission = 'permission'

  _ztree_setting =
    check:
      enable: true
  $ztree = $.fn.commom.permissions_tree.init('#permission_tree', window.role_id,  _ztree_setting)

  $('#role_form').submit ->
    _permissions = $ztree.getNodesByFilter (node)->
      node.checked && node.type == _permission

    $permissions_div.children().remove()
    #把权限数据写入
    for permission in _permissions
      $permissions_div.append($("<input type='hidden' name='role[role_permissions_attributes][][permission_id]' value='#{permission.model_id}'>"))
    true



  $('#role_form').validator_b3({
    errorElement: 'div',
    errorClass: 'help-block',
    focusInvalid: false,
    rules: {
      "role[name]": {
        required: true
      }
    },
    messages: {
    }
  });


  $('.nav.nav-list li.active').removeClass('active');
  $('.nav.nav-list li[data-model="role_list"]').addClass('active');
