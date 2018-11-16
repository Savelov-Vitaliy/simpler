module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :param

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @method == method && @path.match(path)
      end

    end
  end
end
