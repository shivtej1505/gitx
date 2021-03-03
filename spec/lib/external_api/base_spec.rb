# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalApi::Base do
  before(:each) do
    @base_url = Faker::Internet.url(path: nil)
    @endpoint = FactoryBot.build(:endpoint)
    @url = "#{@base_url}/#{@endpoint}"
    @headers = FactoryBot.build(:headers)
  end

  ExternalApi::METHODS.each do |method|
    describe "On randomly generated URL" do
      context "when #{method.upcase} request is performed" do
        it "hits correct URL with correct headers" do
          # setup
          stub_request(method, @url)

          # exercise
          api_client = ExternalApi::Base.new(base_url: @base_url)
          api_client.make_request(endpoint: @endpoint, method: method, headers: @headers)

          # verify
          expect(WebMock).to have_requested(method, @url).with(headers: @headers)
        end

        it "hits correct URL with correct headers and return correct response" do
          # setup
          expected_response_body = Faker::Types.rb_hash
          stub_request(method, @url).to_return(body: expected_response_body.to_json, headers: @headers)

          # exercise
          api_client = ExternalApi::Base.new(base_url: @base_url)
          response = api_client.make_request(endpoint: @endpoint, method: method, headers: @headers)

          # verify
          expect(WebMock).to have_requested(method, @url).with(headers: @headers)
          expect(response.body).to eq(expected_response_body.to_json)
        end
      end
    end
  end

  ExternalApi::METHODS_WITH_PARAMS.each do |method|
    describe "On randomly generated URL" do
      context "when #{method.upcase} request is performed" do
        it "hits correct URL with correct params" do
          # setup
          opts = Faker::Types.rb_hash
          stub_request(method, @url).with(query: opts)

          # exercise
          api_client = ExternalApi::Base.new(base_url: @base_url)
          api_client.make_request(endpoint: @endpoint, method: method, headers: @headers, params: opts)

          # verify
          expect(WebMock).to have_requested(method, @url).with(query: opts, headers: @headers)
        end
      end
    end
  end

  ExternalApi::METHODS_WITH_BODY.each do |method|
    describe "On randomly generated URL" do
      context "when #{method.upcase} request is performed" do
        it "hits correct URL with correct body" do
          # setup
          body = JSON.generate(Faker::Types.rb_hash)
          stub_request(method, @url)

          # exercise
          api_client = ExternalApi::Base.new(base_url: @base_url)
          api_client.make_request(endpoint: @endpoint, method: method, headers: @headers, body: body)

          # verify
          expect(WebMock).to have_requested(method, @url).with(headers: @headers, body: body)
        end
      end
    end
  end
end

RSpec.describe ExternalApi::Base, "Invalid HTTP method" do
  before(:each) do
    @base_url = Faker::Internet.url(path: nil)
    @endpoint = FactoryBot.build(:endpoint)
    @api_client = ExternalApi::Base.new(base_url: @base_url)
  end

  context "when invalid method is passed" do
    it "throws Argument Error" do
      expect {
        invalid_method = "GUT".to_sym
        @api_client.make_request(endpoint: @endpoint, method: invalid_method)
      }.to raise_error(ArgumentError)
    end
  end

  context "when method with invalid class is passed" do
    it "throws Argument Error" do
      expect {
        invalid_method = "GUT"
        @api_client.make_request(endpoint: @endpoint, method: invalid_method)
      }.to raise_error(ArgumentError)
    end
  end
end
