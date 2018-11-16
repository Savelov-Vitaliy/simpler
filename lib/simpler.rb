require 'pathname'
require_relative 'simpler/application'

module Simpler

  class << self
    def application
      Application.instance
    end

    def root
      Pathname.new(File.expand_path('..', __dir__))
    end
  end

end

class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end
