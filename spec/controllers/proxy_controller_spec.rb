require 'rails_helper'

RSpec.describe ProxyController, type: :request do
  github_api_base_url = "https://api.github.com"
  WebMock.allow_net_connect!
  describe "Github proxy when requested to list down repositories from a user's account" do
    context "without auth token" do
      it "make request to Github api endpoint" do
        # setup
        endpoint = "/user/repos"
        request_headers = FactoryBot.build(:headers_without_auth_token)
        github_endpoint = github_api_base_url + endpoint

        # test
        get "/api" + endpoint, headers: request_headers

        # test
        expect(a_request(:get, github_endpoint).with(headers: request_headers)).to have_been_made.once
      end
    end

    context "with auth token" do
      it "make request to Github api endpoint" do
        # setup
        endpoint = "/user/repos"
        request_headers = FactoryBot.build(:headers_with_auth_token)
        github_endpoint = github_api_base_url + endpoint

        # test
        get "/api" + endpoint, headers: request_headers

        # test
        expect(a_request(:get, github_endpoint).with(headers: request_headers)).to have_been_made.once
      end
    end
  end
end
