require_relative 'utils/extensions'
require_relative 'view'

module Simpler
  class Controller
    using ObjectExtensions

    attr_reader :name, :request, :response, :headers, :params

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @headers = {}
      @params = request_params
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

    private

    def request_params
      @request.params.each.with_object({}) { |param, hash| hash[param[0].to_sym] = param[1] }
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @headers.each { |k, v| @response[k] = v }
      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(template = nil, **format_render)
      @request.env['simpler.template_render'] = template
      @request.env['simpler.format_render'] = format_render
      @response['Content-Type'] = "text/#{format_render}" unless format_render.blank?
    end

    def status(response_status)
      @response.status = response_status
    end
  end
end
