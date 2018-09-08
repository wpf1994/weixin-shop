class Front::BaseController < ApplicationController
  include BreadcurmbModule
  layout :front_layout
  def front_layout
    request.headers['X-PJAX'] ? 'front/pjax' : 'front/application'
  end

end