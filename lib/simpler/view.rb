require 'erb'
require_relative 'view/formats'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      return send(format_render.keys[0], format_render.values[0]) unless format_render.blank?

      template = File.read(template_path)
      ERB.new(template).result(binding)
    end

    def template
      path = template_render || [controller.name, action].join('/')
      "#{path}.html.erb"
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template_render
      @env['simpler.template_render']
    end

    def format_render
      @env['simpler.format_render']
    end

    def template_path
      Simpler.root.join(VIEW_BASE_PATH, template)
    end

  end
end
