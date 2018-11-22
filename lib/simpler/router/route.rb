module Simpler
  class Router
    class Route
      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @method == method && path_match?(path)
      end

      def params(env)
        request = Rack::Request.new(env)

        route_path_parts = @path.split('/').reject(&:empty?)
        env_path_parts = request.env['PATH_INFO'].split('/').reject(&:empty?)

        route_path_parts.each_with_index.with_object({}) do |route_path_part_and_index, params|
          part  = route_path_part_and_index[0]
          index = route_path_part_and_index[1]

          params[part[1..-1].to_sym] = env_path_parts[index] if part[0] == ':'
        end
      end

      private

      def path_parts(path)
        path.split('?')[0].split('/').reject(&:empty?)
      end

      def path_match?(path)
        route_path_parts = path_parts(@path)
        get_path_parts = path_parts(path)

        # количество частей обоих путей должно быть одинаковым (части разделенны "/")
        return false unless route_path_parts.size == get_path_parts.size

        # если есть хотя бы одна часть пути маршрута, которая:
        # 1) не параметр (т.е. не начитается с ":")
        # и при этом
        # 2) не равна аналогичной части переданного пути (с тем же индексом)
        # то этот маршрут не подходит: return false
        route_path_parts.each_with_index do |part, index|
          return false unless part[0] == ':' || get_path_parts[index] == part
        end
        true
      end
    end
  end
end
