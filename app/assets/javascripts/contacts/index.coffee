$ ->
  $('.nav.nav-list li.active').removeClass('active');
  $('.nav.nav-list li[data-model="contacts"]').addClass('active');
  $('.nav.nav-list li[data-model="contacts"] ul.submenu li[data-model="contact_list"]').addClass('active');

  $group_tree = $.fn.commom.contacts_groups_tree.init($('#group_tree'))
  if(window.cur_group)
    $(window.cur_group.split(',')).each (index, current)=>
      if(current == 'null')
        current = -1
      selected_nodes = $group_tree.getNodesByParam("id", current, null);
      if(selected_nodes.length > 0)
        $group_tree.selectNode(selected_nodes[0])