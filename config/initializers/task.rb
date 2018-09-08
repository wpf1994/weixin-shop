# # coding: UTF-8
# require 'soap/wsdlDriver'
# require 'rufus-scheduler'
# scheduler = Rufus::Scheduler.new
# soap_client = nil
#
# #每5秒执行一次


#
def safely
  begin
    unless ActiveRecord::Base.connected?
      ActiveRecord::Base.connection.verify!(0)
    end
    yield
  rescue => e
    # status e.inspect
    puts e
  ensure
    ActiveRecord::Base.connection_pool.release_connection
  end
end

