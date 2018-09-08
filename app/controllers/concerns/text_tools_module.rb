# coding: UTF-8
module TextToolsModule
  def create_success_notice(model_name)
    "#{t ('activerecord.models.'<< model_name.to_s)}#{t 'common.create'}#{t 'common.success'}。"
  end

  def update_success_notice(model_name)
    "#{t ('activerecord.models.'<< model_name.to_s)}#{t 'common.update'}#{t 'common.success'}。"
  end

  def destroy_success_notice(model_name)
    "#{t ('activerecord.models.'<< model_name.to_s)}#{t 'common.destroy'}#{t 'common.success'}。"
  end
end