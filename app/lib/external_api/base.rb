# frozen_string_literal: true

module ExternalApi
  METHODS = [:get, :post, :put, :delete, :head, :patch].freeze
  METHODS_WITH_PARAMS = [:get, :head, :delete].freeze
  METHODS_WITH_BODY = [:post, :put, :patch].freeze

  class Base
    def initialize(base_url:)
      @connection = Faraday.new(url: base_url) { |faraday|
        faraday.response :json, content_type: /\bjson$/
      }
    end

    def make_request(endpoint:, method:, body: {}, params: {}, headers: {})
      unless method.is_a?(Symbol)
        raise ArgumentError, "Invalid method type. Expected Symbol, found #{method.class}"
      end

      unless METHODS.include?(method)
        raise ArgumentError, "unknown http method: #{method}"
      end

      if method_with_body?(method)
        run_request_with_body(method, endpoint, body, headers)
      else
        run_request_with_params(method, endpoint, params, headers)
      end
    ensure
      @connection.close
    end

    private

    def method_with_body?(method)
      METHODS_WITH_BODY.include?(method)
    end

    def run_request_with_body(method, endpoint, body, headers)
      @connection.run_request(method, endpoint, body, headers)
    end

    def run_request_with_params(method, endpoint, params, headers)
      @connection.params = params
      @connection.run_request(method, endpoint, nil, headers)
    end
  end
end
