require 'logger'

class AppLogger

  def initialize(app, **options)
    @app = app
    @logger = Logger.new(options[:logdev] || STDOUT)
  end

  def call(env)
    status, headers, body = @app.call(env)

    to_log(env, status, headers)

    [status, headers, body]
  end

  private

  def to_log(env, status, headers)
    request = Rack::Request.new(env)

    @logger.info("Request: #{request.request_method} #{request.fullpath}")
    @logger.info("Handler: #{request.get_header('simpler.controller').class.name}##{request.get_header('simpler.action')}")
    @logger.info("Parameters: #{request.params}")
    @logger.info("Response: #{status} [#{headers['Content-Type']}] #{request.get_header('simpler.template')}")
  end


end
