# frozen_string_literal: true

module ExternalApi
  # We could have assigned variable from Faraday's variable. Why didn't we do that?
  METHODS = [:get, :post, :put, :delete, :head, :patch].freeze
  METHODS_WITH_PARAMS = [:get, :head, :delete].freeze
  METHODS_WITH_BODY = [:post, :put, :patch].freeze

  class Base
    def initialize(base_url:)
      # Does it make new connection every time?
      # Does it keep the same connection open?
      @connection = Faraday.new(url: base_url) { |connection|
        # This content type works for Github like json standard too
        connection.response :json, content_type: /\bjson$/
      }
      # TODO: How do I make sure connection is not being reused? Should it be reused?
      # How can I make sure connection is closed & I'm not leaving any open connection behind?
    end

    def make_request(endpoint:, method:, body: {}, params: {}, headers: {})
      # How do I efficiently make all kinds of requests, without any code repetition
      # I can copy paste things from Faraday but that might be not good

      unless method.is_a?(Symbol)
        raise ArgumentError, "Invalid method type. Expected Symbol, found #{method.class}"
      end

      unless METHODS.include?(method)
        raise ArgumentError, "unknown http method: #{method}"
      end

      # Is it cool?
      @method = method
      @endpoint = endpoint
      @headers = headers
      @body = body
      @params = params

      if method_with_body?
        run_request_with_body
      else
        run_request_with_params
      end

      # Run it inside block & close connection
      # @connection.close
      response
    end

    private

    def method_with_body?
      METHODS_WITH_BODY.include?(@method)
    end

    def method_with_params?
      METHODS_WITH_PARAMS.include?(@method)
    end

    def run_request_with_body
      @connection.run_request(@method, @endpoint, @body, @headers)
    end

    def run_request_with_params
      @connection.params = @params
      @connection.run_request(@method, @endpoint, nil, @headers)
    end
  end
end
