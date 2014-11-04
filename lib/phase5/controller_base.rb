require_relative '../phase4/controller_base'
require_relative './params'
require 'uri'

module Phase5
  class ControllerBase < Phase4::ControllerBase
    attr_reader :params

    # setup the controller
    def initialize(req, res, route_params = {})
    end

    def [](key)
      @route_params["#{key.to_s}"]
    end
  end
end
