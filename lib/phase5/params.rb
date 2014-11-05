require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:

    def initialize(req, route_params = {})
      @params = route_params
      @params
        .merge!(parse_www_encoded_form(req.query_string)) if req.query_string
      @params.merge!(parse_www_encoded_form(req.body)) if req.body
    end

    def nested_key?(key)
      parse_key(key).length > 1
    end

    def [](key)
      @params["#{key}"]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end

    private
    # this should return deeply nested hash
    # argument format
    # parse_www_encoded_form("user[address][street]=main&user[address][zip]=89436")
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }

    def parse_www_encoded_form(www_encoded_form)
      key_vals = URI::decode_www_form(www_encoded_form)

      render_www_to_hash(key_vals)
    end

    def render_www_to_hash(key_value_sets)
      params = {}
      key_value_sets.each do |key_string, val|
        key_set = parse_key(key_string)
        current = params

        key_set[0..-2].each do |key|
          current[key] ||= {}
          current = current[key]
        end
        current[key_set.last] = val
      end

      params
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
