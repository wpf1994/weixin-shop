$ ->
  $('#user_form').validator_b3({
    errorElement: 'div',
    errorClass: 'help-block',
    focusInvalid: false,
    rules: {
      "user[name]": "required",
      "user[email]": {
        required: true,
        email: true
      },
      "user[phone]": "required",
      #"user[organization]": "required",
      "user[password]": {
        minlength: 8
      }
    },
    messages: {
    }
  });

  $('.nav.nav-list li.active').removeClass('active');
  $('.nav.nav-list li[data-model="user_list"]').addClass('active');

  $roles_div = $('#roles_div')
  _role = 'role'

  _ztree_setting =
    check:
      enable: true
  $ztree_roles = $.fn.commom.roles_tree.init('#roles_tree', window.user_id,  _ztree_setting)

  $('#user_form').submit ->
    _roles = $ztree_roles.getNodesByFilter (node)->
      node.checked && node.type == _role

    $roles_div.children().remove()
    #把权限数据写入
    for role in _roles
      $roles_div.append($("<input type='hidden' name='user[user_roles_attributes][][role_id]' value='#{role.model_id}'>"))



    true