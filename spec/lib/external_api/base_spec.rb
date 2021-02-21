require "rails_helper"
require "request_helper"

RSpec.describe ExternalApi::Base do
  all_verbs.each do |method|
    base_url = base_url_generator
    describe "#{method} on randomly generated endpoint" do
      context "when requested" do
        it "hit correct url with correct header" do
          # setup
          endpoint, request_headers = request_params
          stub_request_with_base_url(method, base_url, endpoint)

          # test
          ext_api = ExternalApi::Base.new(base_url: base_url)
          ext_api.do_request(endpoint: endpoint, method: method, headers: request_headers)

          # except
          expect(WebMock).to have_requested(method, "#{base_url}/#{endpoint}").with(headers: request_headers)
        end
      end

      context "when requested with params" do
        it "hit correct url with params" do
          # setup
          endpoint, request_headers = request_params
          opts = Faker::Types.rb_hash
          stub_request_with_base_url(method, base_url, endpoint).with(query: opts)

          # test
          ext_api = ExternalApi::Base.new(base_url: base_url)
          ext_api.do_request(endpoint: endpoint, method: method, headers: request_headers, opts: opts)

          # except
          expect(WebMock).to have_requested(method, "#{base_url}/#{endpoint}").with(query: opts, headers: request_headers)
        end
      end

      context "when requested" do
        it "hit correct url with correct header and return correct response & status" do
          # setup
          endpoint, request_headers = request_params
          expected_response_body = Faker::Types.rb_hash
          expected_status = FactoryBot.build(:status_code)

          stub_request_with_base_url(method, base_url, endpoint)
            .to_return(body: expected_response_body.to_json, status: expected_status, headers: request_headers)

          # test
          ext_api = ExternalApi::Base.new(base_url: base_url)
          response = ext_api.do_request(endpoint: endpoint, method: method, headers: request_headers)

          # except
          expect(WebMock).to have_requested(method, "#{base_url}/#{endpoint}").with(headers: request_headers)
          expect(response.read_body).to eq(expected_response_body.to_json)
          expect(response.code.to_i).to eq(expected_status)
        end
      end
    end
  end

  post_kind_verbs.each do |method|
    base_url = base_url_generator
    describe "#{method} on randomly generated endpoint" do
      context "when requested with body" do
        it "hit correct url with correct body" do
          # setup
          endpoint, request_headers = request_params
          body = Faker::Types.rb_hash
          stub_request_with_base_url(method, base_url, endpoint).with(body: body)

          # test
          ext_api = ExternalApi::Base.new(base_url: base_url)
          ext_api.do_request(endpoint: endpoint, method: method, headers: request_headers, body: body)

          # except
          expect(WebMock).to have_requested(method, "#{base_url}/#{endpoint}")
            .with(headers: request_headers, body: body)
        end
      end
    end
  end
end
