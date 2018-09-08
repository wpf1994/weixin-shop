$ ->
  @show_box = (id)->
    jQuery('.widget-box.visible').removeClass('visible')
    jQuery('#'+id).addClass('visible');


  $browser_alert = $('#browser_alert')
  if($.browser.msie && $.browser.version < 9)
    #处理浏览器提示
    $browser_alert.html("您使用的IE浏览器版本过低，请下载
                  <a href='http://windows.microsoft.com/zh-cn/internet-explorer/download-ie' target='_blank'>新版IE浏览器</a>
                或者使用其他推荐浏览器")
    $browser_alert.removeClass('hide')
