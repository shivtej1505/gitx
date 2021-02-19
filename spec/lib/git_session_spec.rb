require "rails_helper"

RSpec.describe Git::Session do
  describe "GET /user/repos" do
    it "on api.github.com to fetch user repo" do
      expected_response_body = [
        {
          "id": 96601484,
          "name": "MegathonWebsite",
          "full_name": "ayushpateria/MegathonWebsite",
          "private": true,
          "description": "Website of Hackathon"
        }
      ]

      stub_request(:get, "https://api.github.com/user/repos").to_return(body: expected_response_body)

      endpoint = "user/repos"
      method = "GET"
      body = {}
      headers = {
        "Authorization": "token some-random-generated-token",
        "Accept": "application/vnd.github.v3+json"
      }
      opts = {}

      git = Git::Session.new
      response = git.do_request(endpoint: endpoint, method: method, body: body, headers: headers, opts: opts)

      response_body = response.read_body

      expect(response.code.to_i).to eq(200)
      expect(response_body).to eq(expected_response_body)
    end
  end
end
