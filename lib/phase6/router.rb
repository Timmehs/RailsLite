module Phase6
  class Route
    attr_reader :pattern, :http_method, :controller_class, :action_name

    def initialize(pattern, http_method, controller_class, action_name)
      @pattern = pattern
      @http_method = http_method
      @controller_class = controller_class
      @action_name = action_name
    end

    # checks if pattern matches path and method matches request method
    def matches?(req)
      return false if req.request_method.downcase.to_sym != @http_method
      return false unless req.path =~ @pattern
      true
    end

    # use pattern to pull out route params (save for later?)
    # instantiate controller and call controller action
    def run(req, res)
      route_params = extract_route_params(req.path)
      controller = @controller_class.new(req, res, route_params)
      controller.invoke_action(@action_name)
    end

    def extract_route_params(path)
      match_data = @pattern.match(path)
      route_params = {}
      match_data.names.each do |key|
        route_params[key] = match_data[key]
      end

      route_params
    end
  end

  class Router
    attr_reader :routes

    def initialize
      @routes = []
    end

    # simply adds a new route to the list of routes
    def add_route(pattern, method, controller_class, action_name)
      new_route = Route.new(pattern, method, controller_class, action_name)
      @routes << new_route
    end

    # evaluate the proc in the context of the instance
    # for syntactic sugar :)
    def draw(&proc)
      self.instance_eval(&proc)
    end

    # make each of these methods that
    # when called add route
    [:get, :post, :put, :delete].each do |http_method|
      define_method(http_method) do |*args|
        add_route(args[0], :get, args[1], args[2])
      end
    end

    # should return the route that matches this request
    def match(req)
      @routes.each do |route|
        return route if route.matches?(req)
      end
      nil
    end

    # either throw 404 or call run on a matched route
    def run(req, res)
      route = match(req)
      return res.status = 404 unless route
      route.run(req, res)
    end
  end
end
