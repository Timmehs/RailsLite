require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      @req = req
      @req.cookies.each do |cook|
        @cookie = JSON.parse(cook.value) if cook.name == "_rails_lite_app"
      end
      @cookie ||= {}
    end

    def [](key)
      @cookie["#{key}"]
    end

    def []=(key, val)
      @cookie["#{key}"] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      session_cookie =
        WEBrick::Cookie.new("_rails_lite_app", @cookie.to_json)
      res.cookies << session_cookie
    end
  end
end
