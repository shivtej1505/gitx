require "rails_helper"

RSpec.describe ProxyController do
  github_api_base_url = "https://api.github.com"
  WebMock.allow_net_connect!(allow: github_api_base_url)
  describe "Github proxy when requested to list down repositories from a user's account" do
    context "without auth token" do
      it "make request to Github api endpoint" do
        # setup
        endpoint = "user/repos"
        request_headers = FactoryBot.build(:headers_without_auth_token)
        github_endpoint = github_api_base_url + "/" + endpoint

        # test
        request_headers.each do |key, value|
          request.headers[key] = value
        end

        get :index, params: {path: endpoint}

        # expect
        expect(a_request(:get, github_endpoint).with(headers: request_headers)).to have_been_made.once
      end
    end

    context "with auth token" do
      it "make request to Github api endpoint" do
        # setup
        endpoint = "user/repos"
        request_headers = FactoryBot.build(:headers_with_auth_token)
        github_endpoint = github_api_base_url + "/" + endpoint

        # test
        request_headers.each do |key, value|
          request.headers[key] = value
        end
        get :index, params: {path: endpoint}

        # expect
        expect(a_request(:get, github_endpoint).with(headers: request_headers)).to have_been_made.once
      end
    end

    context "with params" do
      it "make request to Github api endpoint" do
        # setup
        endpoint = "user/repos"
        request_headers = FactoryBot.build(:headers_with_auth_token)
        github_endpoint = github_api_base_url + "/" + endpoint
        opts = Faker::Types.rb_hash

        # test
        request_headers.each do |key, value|
          request.headers[key] = value
        end
        get :index, params: {path: endpoint}.merge!(opts)

        # expect
        expect(a_request(:get, github_endpoint).with(query: opts).with(headers: request_headers)).to have_been_made.once
      end
    end
  end

  describe "Github proxy when requested to create a repository" do
    context "on a user's behalf with given auth token" do
      it "make request to Github api endpoint with correct headers & body" do
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
end
