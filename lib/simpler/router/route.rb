module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params_indexes = params_indexes
      end

      def match?(method, path)
        @method == method && path_match?(path)
      end

      def params(env)
        request = Rack::Request.new(env)
        get_params = request.env['PATH_INFO'].split('/')
        set_params = @path.split('/')

        set_params.each.with_object({}){|p, h|  h[p[1..-1].to_sym] = get_params[set_params.index(p)] if p[0] == ':'}
      end

      private

      def path_match?(path)
        get = path.split('/')
        set = @path.split('/')
        params = @params_indexes.values

        reject_params(set) == reject_params(get) and not get[params.last].nil?
      end

      def reject_params(path_array)
        path_array.reject { |item| @params_indexes.values.include? path_array.index(item) }
      end

      def params_indexes
        route_params = @path.split('/')
        route_params.each.with_object({}){|k, h| h[k[1..-1].to_sym] = route_params.index(k) if k[0] == ':'}
      end

    end
  end
end
