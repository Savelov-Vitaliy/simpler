require 'json'

module Simpler
  class View
    def plain(body)
      body
    end

    def html(body)
      body
    end

    def json(body)
      body.to_json
    end
  end
end
