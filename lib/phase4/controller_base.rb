require_relative '../phase3/controller_base'
require_relative './session'

module Phase4
  attr_reader :session
  class ControllerBase < Phase3::ControllerBase
    def redirect_to(url)
      super
      session.store_session(@res)
    end

    def render_content(content, type)
      super
      session.store_session(@res)
    end

    # method exposing a `Session` object
    def session
      @session ||= Session.new(@req)
    end

    # Method exposing a 'Flash' object
    def flash
      @session.flash
    end
  end
end
