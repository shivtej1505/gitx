# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalApi::Base do
  ExternalApi::METHODS.each do |method|
    base_url = Faker::Internet.url(path: nil) # test should be isolated. Let's move it inside text itself??
    describe "On randomly generated URL" do
      context "when #{method.upcase} request is performed" do
        it "hits correct URL with correct headers" do
          # setup
          endpoint = FactoryBot.build(:endpoint)
          headers = FactoryBot.build(:headers)
          url = "#{base_url}/#{endpoint}"
          stub_request(method, url)

          # exercise
          ext_api = ExternalApi::Base.new(base_url: base_url)
          ext_api.make_request(endpoint: endpoint, method: method, headers: headers)

          # verify
          # TODO: Other headers are also coming (User-Agent, Accept-Encoding, etc). What to do about it?
          expect(WebMock).to have_requested(method, url).with(headers: headers)
        end

        it "hits correct URL with correct headers and return correct response" do
          # setup
          endpoint = FactoryBot.build(:endpoint)
          headers = FactoryBot.build(:headers)
          url = "#{base_url}/#{endpoint}"
          expected_response_body = Faker::Types.rb_hash

          stub_request(method, url).to_return(body: expected_response_body.to_json, headers: headers)

          # exercise
          ext_api = ExternalApi::Base.new(base_url: base_url)
          response = ext_api.make_request(endpoint: endpoint, method: method, headers: headers)

          # verify
          expect(WebMock).to have_requested(method, url).with(headers: headers)
          expect(response.body).to eq(expected_response_body.to_json)
        end
      end
    end
  end

  ExternalApi::METHODS_WITH_PARAMS.each do |method|
    base_url = Faker::Internet.url(path: nil)
    describe "On randomly generated URL" do
      context "when #{method.upcase} request is performed" do
        it "hits correct URL with correct params" do
          # setup
          endpoint = FactoryBot.build(:endpoint)
          headers = FactoryBot.build(:headers)
          opts = Faker::Types.rb_hash
          url = "#{base_url}/#{endpoint}"
          stub_request(method, url).with(query: opts)

          # exercise
          ext_api = ExternalApi::Base.new(base_url: base_url)
          ext_api.make_request(endpoint: endpoint, method: method, headers: headers, params: opts)

          # verify
          expect(WebMock).to have_requested(method, url).with(query: opts, headers: headers)
        end
      end
    end
  end

  ExternalApi::METHODS_WITH_BODY.each do |method|
    base_url = Faker::Internet.url(path: nil)
    describe "On randomly generated URL" do
      context "when #{method.upcase} request is performed" do
        it "hits correct URL with correct body" do
          # setup
          endpoint = FactoryBot.build(:endpoint)
          headers = FactoryBot.build(:headers)
          body = JSON.generate(Faker::Types.rb_hash)
          url = "#{base_url}/#{endpoint}"
          stub_request(method, url)

          # exercise
          ext_api = ExternalApi::Base.new(base_url: base_url)
          ext_api.make_request(endpoint: endpoint, method: method, headers: headers, body: body)

          # verify
          # TODO: Make it one_time
          expect(WebMock).to have_requested(method, url)
            .with(headers: headers, body: body)
        end
      end
    end
  end
end
