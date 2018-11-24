require_relative 'utils/extensions'
require_relative 'view'

module Simpler
  class Controller
    using ObjectExtensions

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.template'] = View.new(@request.env).template

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    def params
      request_params.merge @request.env['simpler.route.params']
    end

    def headers
      @response
    end

    private

    def request_params
      @request.params.each.with_object({}) { |param, hash| hash[param[0].to_sym] = param[1] }
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      headers['Content-Type'] = 'text/html'
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
      headers['Content-Type'] = "text/#{format_render}" unless format_render.blank?
    end

    def status(response_status)
      @response.status = response_status
    end
  end
end
