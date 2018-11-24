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
        path = Rack::Request.new(env).path_info

        path_parts(@path).each.with_index.with_object({}) do |(part, index), params|
          params[part[1..-1].to_sym] = path_parts(path)[index] if part[0] == ':'
        end
      end

      private

      def path_parts(path)
        path.split('?')[0].split('/').reject(&:empty?)
      end

      def path_match?(path)
        path.match(pattern) && path_parts(path).size == path_parts(@path).size
      end

      def pattern
        path_parts(@path).map { |part| part[0] == ':' ? '.+' : part }.join('/')
      end

      #      # еще один рабочий вариант
      #
      #      MATCH_REGEXP = %r{(?<=\/)(:.+?)(?=\/|$)}.freeze
      #
      #      def path_match?(path)
      #        path.match(@path.gsub(MATCH_REGEXP) { '.+' }) && path_parts(path).size == path_parts(@path).size
      #      end
      #
      #       # альтернативный (старый) вариант
      #
      #       def path_match?(path)
      #         route_path_parts = path_parts(@path)
      #         get_path_parts = path_parts(path)
      #
      #         # количество частей обоих путей должно быть одинаковым (части разделенны "/")
      #         return false unless route_path_parts.size == get_path_parts.size
      #
      #         # если есть хотя бы одна часть пути маршрута, которая:
      #         # 1) не параметр (т.е. не начитается с ":")
      #         # и при этом
      #         # 2) не равна аналогичной части переданного пути (с тем же индексом)
      #         # то этот маршрут не подходит: return false
      #         route_path_parts.each_with_index do |part, index|
      #           return false unless part[0] == ':' || get_path_parts[index] == part
      #         end
      #         true
      #       end
    end
  end
end
