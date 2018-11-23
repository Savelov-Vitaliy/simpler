require_relative 'utils/extensions'
require_relative 'view'

module Simpler
  class Controller
    using ObjectExtensions

    attr_reader :name, :request, :response, :headers

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @headers = {}
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.template'] = View.new(@request.env).template

      send(action)
      set_default_headers
      write_response

      @response.finish
    end

    def params
      request_params.merge @request.env['simpler.route'].params(@request.env)
    end

    private

    def request_params
      @request.params.each.with_object({}) { |param, hash| hash[param[0].to_sym] = param[1] }
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      set_header('Content-Type', 'text/html')
    end

    def set_header(name, value)
      @response.headers[name] = value
    end

    def write_response
      body = render_body

      @headers.each { |header, value| set_header(header, value) }
      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(template = nil, **format_render)
      @request.env['simpler.template_render'] = template
      @request.env['simpler.format_render'] = format_render
      set_header('Content-Type', "text/#{format_render}") unless format_render.blank?
    end

    def status(response_status)
      @response.status = response_status
    end
  end
end
