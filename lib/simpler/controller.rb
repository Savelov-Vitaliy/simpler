require_relative 'view'
require_relative 'controller/headers'

module Simpler
  class Controller

    attr_reader :name, :request, :response, :headers, :params

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @headers = Headers.new(@response)
      @params = id
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['handler'] = "#{self.class.name}##{action}"
      @request.env['template'] = View.new(@request.env).template

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def id
      id = @request.env['PATH_INFO'].match(/\d.*$/)
      { id: id.to_s } if id
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(template = nil, **format_render)
      @request.env['simpler.template_render'] = template
      @request.env['simpler.format_render'] = format_render
    end

    def status(response_status)
      @response.status = response_status
    end


  end
end
