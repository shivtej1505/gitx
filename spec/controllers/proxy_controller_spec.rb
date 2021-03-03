# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProxyController, "as Github Proxy" do
  github_api_base_url = "https://api.github.com"
  WebMock.allow_net_connect!(allow: github_api_base_url)

  describe "when requested to list down repositories from a user's account" do
    before(:each) do
      @endpoint = "user/repos"
      @github_url = github_api_base_url + "/" + @endpoint
    end

    context "without passing Auth header" do
      it "make request to Github API endpoint without Auth header" do
        # setup
        request_headers = FactoryBot.build(:headers_without_auth_token)

        # test
        request_headers.each do |key, value|
          request.headers[key] = value
        end

        get :index, params: {path: @endpoint}

        # expect
        expect(a_request(:get, @github_url)
                 .with(headers: request_headers)).to have_been_made.once
      end
    end

    context "with Auth header" do
      it "make request to Github API endpoint with Auth header" do
        # setup
        request_headers = FactoryBot.build(:headers_with_auth_token)

        # test
        request_headers.each do |key, value|
          request.headers[key] = value
        end
        get :index, params: {path: @endpoint}

        # expect
        expect(a_request(:get, @github_url)
                 .with(headers: request_headers)).to have_been_made.once
      end
    end

    context "with params" do
      it "make request to Github API endpoint with passed params" do
        # setup
        request_headers = FactoryBot.build(:headers_with_auth_token)
        params = Faker::Types.rb_hash

        # test
        request_headers.each do |key, value|
          request.headers[key] = value
        end
        get :index, params: {path: @endpoint}.merge!(params)

        # expect
        expect(a_request(:get, @github_url)
                 .with(query: params).with(headers: request_headers)).to have_been_made.once
      end
    end
  end

  describe "when requested to create a repository" do
    context "on a user's behalf with given auth token" do
      it "make request to Github API endpoint with correct headers and body" do
        # setup
        endpoint = "user/repos"
        request_headers = FactoryBot.build(:headers_with_auth_token)
        github_endpoint = github_api_base_url + "/" + endpoint
        request_body = {
          name: Faker::FunnyName.name
        }.to_json

        # test
        request_headers.each do |key, value|
          request.headers[key] = value
        end
        post :index, params: {path: endpoint}, body: request_body

        # expect
        expect(a_request(:post, github_endpoint)
                 .with(headers: request_headers, body: request_body)).to have_been_made.once
      end
    end
  end

  describe "when requested to update a repository" do
    context "on a user's behalf with given auth token and body" do
      it "make request to Github API endpoint with correct headers and body" do
        # setup
        owner_endpoint = FactoryBot.build(:endpoint, {nesting_level: 2})
        endpoint = "repos/#{owner_endpoint}"
        request_headers = FactoryBot.build(:headers_with_auth_token)
        github_endpoint = github_api_base_url + "/" + endpoint
        request_body = {
          name: Faker::FunnyName.name,
          description: Faker::Quote.famous_last_words
        }.to_json

        # test
        request_headers.each do |key, value|
          request.headers[key] = value
        end
        patch :index, params: {path: endpoint}, body: request_body

        # expect
        expect(a_request(:patch, github_endpoint)
                 .with(headers: request_headers, body: request_body)).to have_been_made.once
      end
    end
  end

  describe "when requested to update topics of a repository" do
    context "on a user's behalf with given auth token and body" do
      it "make request to Github API endpoint with correct headers and body" do
        # setup
        owner_endpoint = FactoryBot.build(:endpoint, {nesting_level: 2})
        endpoint = "repos/#{owner_endpoint}/topics"
        request_headers = FactoryBot.build(:headers_with_auth_token)
        github_endpoint = github_api_base_url + "/" + endpoint
        request_body = {
          names: Faker::Lorem.words(number: 4)
        }.to_json

        # test
        request_headers.each do |key, value|
          request.headers[key] = value
        end
        put :index, params: {path: endpoint}, body: request_body

        # expect
        expect(a_request(:put, github_endpoint)
                 .with(headers: request_headers, body: request_body)).to have_been_made.once
      end
    end
  end

  describe "when requested to enable vulnerability alerts" do
    context "on a user's behalf with given auth token" do
      it "make request to Github API endpoint with correct headers" do
        # setup
        owner_endpoint = FactoryBot.build(:endpoint, {nesting_level: 2})
        endpoint = "repos/#{owner_endpoint}/vulnerability-alerts"
        request_headers = FactoryBot.build(:headers_with_auth_token)
        github_endpoint = github_api_base_url + "/" + endpoint

        # test
        request_headers.each do |key, value|
          request.headers[key] = value
        end
        put :index, params: {path: endpoint}

        # expect
        expect(a_request(:put, github_endpoint)
                 .with(headers: request_headers)).to have_been_made.once
      end
    end
  end

  describe "when requested to delete a repository" do
    context "on a user's behalf with given auth token" do
      it "make request to Github API endpoint with correct headers" do
        # setup
        owner_endpoint = FactoryBot.build(:endpoint, {nesting_level: 2})
        endpoint = "repos/#{owner_endpoint}"
        request_headers = FactoryBot.build(:headers_with_auth_token)
        github_endpoint = github_api_base_url + "/" + endpoint

        # test
        request_headers.each do |key, value|
          request.headers[key] = value
        end
        delete :index, params: {path: endpoint}

        # expect
        expect(a_request(:delete, github_endpoint)
                 .with(headers: request_headers)).to have_been_made.once
      end
    end
  end
end
