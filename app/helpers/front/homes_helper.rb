module Front::HomesHelper
  APP_ID='wxd247a3068c4e05f6'
  APP_SECRET='ee2d8c9f9b9185de0c181b24b41651de'

  # 获取openid
  def authenticate_openid!(code = params[:code])
    has_redirect = false
    # 当session中没有openid时，则为非登录状态
    if session[:weixin_openid].blank?
      # 如果code参数为空，则为认证第一步，重定向到微信认证
      if code.nil?
        has_redirect = true
        redirect_to "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{APP_ID}&redirect_uri=#{'http://www.cqpssm.net'}&response_type=code&scope=snsapi_base&state=basic#wechat_redirect", status: 303
      else
        #如果code参数不为空，则认证到第二步，通过code获取openid，并保存到session中
        json = get_access_token code
        session[:weixin_openid] = json["openid"]
      end
    end
    return session[:weixin_openid], has_redirect
  rescue => e
    GeneralLog.write(:openid, "authenticate_openid!函数出现异常：#{e.message}\n#{e.backtrace.join("\n")}")
    return nil, false
  end

  # 提示oauth2登录
  def oauth2_weixin(code=params[:code])
    has_redirect = false
    if code.nil?
      url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxd247a3068c4e05f6&redirect_uri=#{request.url}&response_type=code&scope=snsapi_userinfo&state=oauth#wechat_redirect"
      redirect_to url, status: 303
      has_redirect = true
      user = nil
    else
      # 取微信返回的access_token和openid
      sns_info = get_access_token(code)
      # 通过上面的数据, 获取到用户的详细信息
      user_info = get_user_info(sns_info['access_token'], sns_info['openid'])
      # 通过相信信息创建或查找出用户
      user = create_customer_with_openid user_info
    end

    return user, has_redirect
  rescue => e
    GeneralLog.write(:openid, "oauth2_weixin函数出现异常：#{e.message}\n#{e.backtrace.join("\n")}")
    return nil, false
  end

  # 微信入口
  def weixin_entry
    code, state = params[:code], params[:state]
    case state
      when 'basic'
        user, redirect = weixin_entry_basic(code)
      when 'oauth'
        user, redirect =oauth2_weixin(code)
      else
        user, redirect= weixin_entry_basic(code)
    end
    return user, redirect
  end

  # 微信入口 - 子函数 - 获取用户openid, 如果该openid已经有用户了, 则直接返回, 没有则进行oauth2登录
  def weixin_entry_basic(code)
    openid, redirect = authenticate_openid!
    user = User.all.joins('inner join customers on customers.id=users.owner_id and users.owner_type="Customer"').find_by('customers.weixin_id=?', openid)

    user, redirect = oauth2_weixin(code) if user.nil? and !redirect
    return user, redirect
  end

  def phone_isunique!
    temp = Random.rand(10000000000..99999999999)
    if User.find_by(phone: temp)
      phone_isunique!
    else
      return temp
    end
  end

  private

  # 获取access_token
  def get_access_token(code)
    http =get_weixin_http_client
    path="/sns/oauth2/access_token?appid=#{APP_ID}&secret=#{APP_SECRET}&code=#{code}&grant_type=authorization_code"
    GeneralLog.write(:openid, "开始请求：#{path}")
    request = Net::HTTP::Post.new(path)
    request.add_field('Content-Type', 'application/json')
    response = http.request(request)
    json = JSON.parse(response.body)
    GeneralLog.write(:openid, "请求的json格式数据：#{json}")
    json
  end

  # 通过accesstoken获取用户信息
  def get_user_info(access_token, open_id)
    return nil if access_token.nil? or open_id.nil?
    GeneralLog.write(:openid, "开始请求用户基本数据：#{[access_token, open_id]}")
    http = get_weixin_http_client
    path = "/sns/userinfo?access_token=#{access_token}&openid=#{open_id}&lang=zh_CN"

    request = Net::HTTP::Get.new(path)
    request.add_field('Content-Type', 'application/json')
    response = http.request(request)
    user_info = JSON.parse(response.body)
    GeneralLog.write(:openid, "获取到用户的基本数据：#{user_info}")

    user_info
  rescue => e
    GeneralLog.write(:openid, "获取用户基本数据失败：#{e.message}")
    return
  end

  # 通过微信返回的用户信息,添加到数据库
  def create_customer_with_openid(user_info)
    return nil if user_info.nil?
    user = User.all.joins('inner join customers on customers.id=users.owner_id and users.owner_type="Customer"').find_by('customers.weixin_id=?', user_info["openid"])
    GeneralLog.write(:openid, "通过user_info查询到的用户是：#{user}")
    return user if user.present?
    customer = Customer.create weixin_id: user_info['openid'], name: user_info['nickname']
    user=User.create(owner: customer, name: customer.name, email: "customer_#{customer.id}@qq.com", phone: phone_isunique!, password: 12345678, password_confirmation: 12345678)
    GeneralLog.write(:openid, "没有查询到用户,则我们创建的是：#{user}")
    user
  end

  # 获取微信通用客户端
  def get_weixin_http_client
    url = 'https://api.weixin.qq.com/'
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http
  end
end
