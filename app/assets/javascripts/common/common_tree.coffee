$ = jQuery
if !$.fn.commom
  $.fn.commom = {}

_default_setting =
  data:
    simpleData:
      enable: true

#组织机构作为目录的contacts选择树
$.fn.commom.contacts_tree =
  init: (obj, setting = {}) ->
    init_tree(obj, setting, this.node_data())

  node_data: ->
    $nodes = null
    $.ajax '/front/contacts/tree_data.json',
      type: 'GET'
      detaType: 'json'
      async: false
      error: (jqXHR, textStatus, errorThrown) ->
        alert('获取通讯录失败')
      success: (data, textStatus, jqXHR) ->
        $nodes = data
    $nodes

#role作为目录的people选择树
$.fn.commom.role_people_tree =
  init: (obj, setting = {}) ->
    init_tree(obj, setting, this.node_data())

  node_data: ->
    $nodes = null
    $.ajax '/admin/people/tree_data/rp.json',
      type: 'GET'
      detaType: 'json'
      async: false
      error: (jqXHR, textStatus, errorThrown) ->
        alert('获取人员信息失败')
      success: (data, textStatus, jqXHR) ->
        $nodes = data
    $nodes

#组织机构作为目录的department选择树
$.fn.commom.departments_tree =
  init: (obj, setting = {}) ->
    init_tree(obj, setting, this.node_data())

  node_data: ->
    #加载nodes
    #加载单位部门数据
    $nodex = null
    $.ajax '/admin/departments/tree_data/od.json',
      type: 'GET'
      detaType: 'json'
      async: false
      error: (jqXHR, textStatus, errorThrown) ->
        alert('获取机构信息失败')
      success: (data, textStatus, jqXHR) ->
        $nodex = data
    $nodex

#权限树
$.fn.commom.permissions_tree =
  init: (obj, role_id = null, setting = {}) ->
    init_tree(obj, setting, this.node_data(role_id))

  node_data: (role_id)->
    $nodes = null
    $.ajax '/admin/roles/tree_data/permissions.json',
      type: 'GET'
      detaType: 'json'
      data: {role_id: role_id}
      async: false
      error: (jqXHR, textStatus, errorThrown) ->
        alert('获取权限信息失败')
      success: (data, textStatus, jqXHR) ->
        $nodes = data
    $nodes

#角色树
$.fn.commom.roles_tree =
  init: (obj, person_id = null, setting = {}) ->
    init_tree(obj, setting, this.node_data(person_id))

  node_data: (person_id)->
    $nodes = null
    $.ajax '/admin/roles/tree_data/roles.json',
      type: 'GET'
      detaType: 'json'
      data: {user_id: person_id}
      async: false
      error: (jqXHR, textStatus, errorThrown) ->
        alert('获取角色信息失败')
      success: (data, textStatus, jqXHR) ->
        $nodes = data
    $nodes

#通讯录分组树
$.fn.commom.contacts_groups_tree =
  init: (obj, setting = {}) ->
    init_tree(obj, setting, this.node_data())

  node_data: ->
    $nodes = null
    $.ajax '/front/contacts_groups/load_my_groups',
      type: 'GET'
      detaType: 'json'
      data: {}
      async: false
      error: (jqXHR, textStatus, errorThrown) ->
        alert('获取通讯录分组失败')
      success: (data, textStatus, jqXHR) ->
        $nodes = data
    $nodes


#生成树
init_tree =(obj, setting = {}, nodes = null) ->
  _setting = $.extend({}, _default_setting, setting)
  #加载node
  $ztree = $.fn.zTree.init($(obj), _setting, nodes);

  $ztree