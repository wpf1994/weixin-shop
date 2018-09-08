class GeneralLog
  class << self
    def write(cate, message)
      path = "#{Rails.root}/log/#{cate}/"
      Dir.mkdir(path) unless Dir.exist? path
      file = File.open("#{path}#{file_name}.log", File::WRONLY | File::APPEND | File::CREAT)
      logger = Logger.new(file, 'daily')
      logger.level = Logger::DEBUG
      logger.info(message)
      logger.close
    end

    private

    def file_name
      Time.now.strftime('%Y-%m-%d')
    end
  end
end