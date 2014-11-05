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
      if req.query_string
        query_string_hash = {}
        query = URI::decode_www_form(req.query_string)
        query.each do |key, val|
          # check if
          if nested_key?(key)

          else
            query_string_hash[key] = val
          end
        end
        @params.merge!(query_string_hash)
      end
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
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }

    def parse_www_encoded_form(www_encoded_form)
      key_vals = URI::decode_www_form(www_encoded_form)
      hashes = []
      key_vals.each do |key_set, val|
        hash = {}
        parsed_keys = parse_key(key_set).reverse


        parsed_keys.each_with_index do |key, i|
          if i == 0
            hash[key] = val
          else
            hash = { key => { parsed_keys[i - 1] => hash[parsed_keys[i - 1]] } }
          end
        end
        hashes << hash
      end
      hashes
    end


    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end


  end
end
