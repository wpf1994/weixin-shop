$ = jQuery

_setting =
  tmpl_name: 'templates/common_selector' #模板文件名称
  title: '请选择'
  text_handler: (data)->
    #通过数据获取text
    data.name
  value_handler: (data)->
    #通过数据获取value
    data.model_id

$.fn.common_selector =

  init: (obj, setting) ->
    #基础配置------------------------------------------------------------------------------
    _options = $.extend({}, _setting, setting)
    _click_callback = null#点击确定的回调函数
    _selected_multi = true#是否允许多选
    obj_id = obj.attr('id')
    _tab_index = 0
    #树对象
    $ztrees = []
    #选中的数据
    $selected_data = []
    #老数据
    $old_selected_data = []
    #组件处理------------------------------------------------------------------------------
    #处理模板----------
    $model = $.tmpl(_options.tmpl_name, { id: obj_id, title: _options.title })
    $model.appendTo(obj)
    #处理tab
    $tab_nav = $("##{obj_id}_nav")
    $tab_content = $("##{obj_id}_tab_content")
    #模板确定按钮
    $btn_save = $("##{obj_id}_btn_save")
    $btn_save.click ->
      if _click_callback
        _click_callback($selected_data, $old_selected_data)
#      $model.modal('hide')
    #列表清空按钮
    $btn_clear = $("##{obj_id}_btn_clear")
    $btn_clear.click ->
      _clear_selected_data()
      false

    #处理已选择的----------
    $selected = $("##{obj_id}_selected")
    $selected.dblclick (event)->
      selected_item = $selected.children('option:selected')
      value = selected_item.val()
      $($selected_data).each((index, current)->
        if(_options.value_handler(current) == value)
          $selected_data.splice(index, 1)
          return false
      )
      selected_item.remove()


    #内部方法-----------------------------------------------------------------------------
    #判断树节点是否可以被选择
    _tree_can_select = (event, treeId, treeNode)->
      true
    #双击非根节点，返回null或者false表示禁用，返回array为选择的数据
    _tree_select_children = (event, treeId, treeNode)->
      false

    #树节点双击处理
    _tree_onDblClick = (event, treeId, treeNode) ->
      if treeNode == null
        return
      if _tree_can_select(event, treeId, treeNode)#当前节点可以选择
        _add_node_to_select(treeNode)
      else if _tree_select_children
        children_nodes = _tree_select_children(event, treeId, treeNode)#获取该节点下的可以选择的元素添加到列表中，返回null或者false不执行
        if children_nodes && children_nodes != false
          _add_node_to_select(children_nodes)
          return false

    #将数据加入到选择框中
    _add_node_to_select = (treeNodes) ->
      if _selected_multi
        #多选
        #将可以添加的节点加入选择列表
        if $.isArray(treeNodes)
          for node in treeNodes
            if $selected.children("option[value='#{_options.value_handler(node)}']").length == 0
              _add_selected_data(node, false)
        else
          if $selected.children("option[value='#{_options.value_handler(treeNodes)}']").length == 0
            _add_selected_data(treeNodes, false)
      else
        #删除前面的数据
        #单选
        _clear_selected_data()
        if $.isArray(treeNodes)
          _add_selected_data(treeNodes[0], false)
        else
          _add_selected_data(treeNodes, false)


    #将已选择的初始值加入选择列中
    _add_selected_data = (data, init = true) ->
      $old_selected_data.push(data) if init
      $selected_data.push(data)
      $("<option value='#{_options.value_handler(data)}'>#{_options.text_handler(data)}</option> ").appendTo($selected)

    #清空已选中数据
    _clear_selected_data = ->
      $selected_data.splice(0, $selected_data.length);
      $selected.children().remove()


    #公开方法-----------------------------------------------------------------------------
    handlers =
      ###*
      * 打开选择框
      * @param {boolean} selected_multi 是否是多选
      * @param {Function} selected_data 已经选中的数据  function([ztrees], call_back(data, text, value))
      * @param {Function} success_callback 选择后的回调函数
      * @return null
      ###
      show: (selected_multi, selected_data, success_callback)->
        _selected_multi = selected_multi
        _click_callback = success_callback
        #清空选择框
        _clear_selected_data()
        #清空老数据
        $old_selected_data.splice(0, $old_selected_data.length);
        selected_data($ztrees, _add_selected_data) if selected_data
        $model.modal('show')

      #设置树形插件
      #前两个是ztree插件的参数，
      #handle_options中保存树的操作参数
        # can_select(event, treeId, treeNode)用于判断当前节点是否可以被选则
        # select_children(event, treeId, treeNode)用于判断双击节点执行can_select无效的情况下获取其他要选择的元素
      add_tree: (tab_title, tree_setting, nodes, handle_options)->
        _ztree_setting =
          callback:
            onDblClick: _tree_onDblClick
        _tree_can_select = handle_options.can_select if handle_options && handle_options.can_select
        _tree_select_children = handle_options.select_children if handle_options && handle_options.select_children
        ztree_dom_id = this.add_tree_dom(tab_title)
        $ztree = $.fn.zTree.init($("##{ztree_dom_id}"), $.extend(true, _ztree_setting, tree_setting), nodes)
        $ztrees.push($ztree)
        $ztree


      #添加一个tab
      add_tab_dom: (title, content_dom)->
        content_id = "#{obj_id}_select#{_tab_index}"
        active = if _tab_index == 0 then "active" else ""
        $tab_nav.append($("<li class='#{active}'><a href='##{content_id}' data-toggle='tab'>#{title}</a></li>"))
        $tab_content.append($("<div class='tab-pane #{active}' id='#{content_id}'>#{content_dom}</div>"))

        _tab_index++

      #添加一棵树的dom
      add_tree_dom: (title)->
        ztree_id = "#{obj_id}_ztree#{_tab_index}"
        this.add_tab_dom(title, "<ul id='#{ztree_id}' class='ztree'></ul>")
        return ztree_id

      add_node_to_select: _add_node_to_select
    handlers