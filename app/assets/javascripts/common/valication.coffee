$ ->
  jQuery.extend(jQuery.validator.messages, {
    required: "请输入数据",
    remote: "请修正该字段",
    email: "请输入正确Email地址",
    url: "请输入正确的网址",
    date: "请输入正确的日期",
    dateISO: "请输入正确的日期 (ISO).",
    number: "请输入数字",
    digits: "只能输入整数",
    creditcard: "请输入合法的信用卡号",
    equalTo: "请再次输入相同的值",
    accept: "请输入拥有正确后缀名的字符串",
    maxlength: jQuery.validator.format("数据的最大长度不能超过 {0} "),
    minlength: jQuery.validator.format("数据的最小长度不能低于 {0} "),
    rangelength: jQuery.validator.format("数据的长度介于 {0} 到 {1} 之间"),
    range: jQuery.validator.format("数值的大小介于 {0} 到 {1} 之间"),
    max: jQuery.validator.format("数据的最大值为{0} "),
    min: jQuery.validator.format("数据的最小值为{0} ")
  });
  #jquery validation 默认配置
  default_options =
    highlight: (e)->
      $(e).closest('.form-group').removeClass('has-info').addClass('has-error');

    success: (e) ->
      $(e).closest('.form-group').removeClass('has-error').addClass('has-info');
      $(e).remove();

    errorPlacement: (error, element) ->
      if(element.is(':checkbox') || element.is(':radio'))
        controls = element.closest('div[class*="col-"]');
        if(controls.find(':checkbox,:radio').length > 1)
          controls.append(error)
        else
          error.insertAfter(element.nextAll('.lbl:eq(0)').eq(0));
      else
        error.insertAfter(element.parent());

  #针对Bootstrap3做的校验
  $.fn.validator_b3 = (options)->
    $(this).validate(jQuery.extend(default_options, options))
