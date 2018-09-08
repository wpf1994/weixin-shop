require 'active_support/core_ext/hash/conversions'
require 'minitest/autorun'
require 'wx_pay'
# require 'fakeweb'
# required
WxPay.appid = 'wxd247a3068c4e05f6'
WxPay.key = 'ee2d8c9f9b9185de0c181b24b41651de'
WxPay.mch_id = '1321183901'
# WxPay.appid = 'wxf4a3fcd8ceb7ffa7'
# WxPay.key = 'd6c1030e0b7094aa508f097b05fd4d9c'
# WxPay.mch_id = '1262886801'
# # cert, see https://pay.weixin.qq.com/wiki/doc/api/app.php?chapter=4_3
# # using PCKS12
# WxPay.set_apiclient_by_pkcs12(File.read(pkcs12_filepath), pass)
#
# # optional - configurations for RestClient timeout, etc.
# WxPay.extra_rest_client_options = {timeout: 2, open_timeout: 3}