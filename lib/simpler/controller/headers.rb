module Simpler
  class Controller
    class Headers

      def initialize(response)
        @response = response
      end

      def []=(header, body)
        @response.set_header(header, body)
      end

    end
  end
end
