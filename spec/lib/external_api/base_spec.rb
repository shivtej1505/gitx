# frozen_string_literal: true

require "rails_helper"
require "request_helper"

def init_ext_api(base_url)
  ExternalApi::Base.new(base_url: base_url)
end

RSpec.describe ExternalApi::Base do
  ExternalApi::METHODS.each do |method|
    base_url = base_url_generator
    describe "#{method} on randomly generated endpoint" do
      context "when requested" do
        it "hit correct url with correct header" do
          # setup
          endpoint, request_headers = request_params
          stub_request_with_base_url(method, base_url, endpoint)

          # test
          ext_api = init_ext_api(base_url)
          ext_api.make_request(endpoint: endpoint, method: method, headers: request_headers)

          # except
          # TODO: Other headers are also coming (User-Agent, Accept-Encoding, etc). What to do about it?
          expect(WebMock).to have_requested(method, "#{base_url}/#{endpoint}").with(headers: request_headers)
        end
      end

      context "when requested" do
        it "hit correct url with correct header and return correct response" do
          # setup
          endpoint, request_headers = request_params
          expected_response_body = Faker::Types.rb_hash

          stub_request_with_base_url(method, base_url, endpoint)
            .to_return(body: expected_response_body.to_json, headers: request_headers)

          # test
          ext_api = init_ext_api(base_url)
          response = ext_api.make_request(endpoint: endpoint, method: method, headers: request_headers)

          # Note: This test case is failing randomly. Haven't figure out any pattern yet
          # except
          expect(WebMock).to have_requested(method, "#{base_url}/#{endpoint}").with(headers: request_headers)
          expect(response.body).to eq(expected_response_body.to_json)
        end
      end
    end
  end

  ExternalApi::METHODS_WITH_PARAMS.each do |method|
    base_url = base_url_generator
    describe "#{method} on randomly generated endpoint" do
      context "when requested with params" do
        it "hit correct url with params" do
          # setup
          endpoint, request_headers = request_params
          opts = Faker::Types.rb_hash
          stub_request_with_base_url(method, base_url, endpoint).with(query: opts)

          # test
          ext_api = init_ext_api(base_url)
          ext_api.make_request(endpoint: endpoint, method: method, headers: request_headers, params: opts)

          # except
          expect(WebMock).to have_requested(method, "#{base_url}/#{endpoint}").with(query: opts, headers: request_headers)
        end
      end
    end
  end

  ExternalApi::METHODS_WITH_BODY.each do |method|
    base_url = base_url_generator
    describe "#{method} on randomly generated endpoint" do
      context "when requested with body" do
        it "hit correct url with correct body" do
          # setup
          endpoint, request_headers = request_params
          body = JSON.generate(Faker::Types.rb_hash)
          # Is appending .with ok here?
          stub_request_with_base_url(method, base_url, endpoint)

          # test
          ext_api = init_ext_api(base_url)
          ext_api.make_request(endpoint: endpoint, method: method, headers: request_headers, body: body)

          # except
          # TODO: Make it one_time
          expect(WebMock).to have_requested(method, "#{base_url}/#{endpoint}")
            .with(headers: request_headers, body: body)
        end
      end
    end
  end
end
