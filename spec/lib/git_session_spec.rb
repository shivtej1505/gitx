require "rails_helper"

def headers
  token = Faker::Lorem.characters(number: 40)
  {
    "Authorization": "token #{token}",
    "Accept": "application/vnd.github.v3+json"
  }
end

RSpec.describe Git::Session do
  describe "GET on/some/random/endpoint" do
    context "when requested with no params" do
      it "hit Github url with correct header and returns correct response" do
        endpoint = "on/some/random/endpoint"
        method = "GET"
        request_headers = headers

        # Stub request
        stub_request(:get, "https://api.github.com/#{endpoint}")

        git = Git::Session.new
        git.do_request(endpoint: endpoint, method: method, headers: request_headers)

        expect(WebMock).to have_requested(:get, "https://api.github.com/#{endpoint}").with(headers: request_headers)
      end
    end

    context "when requested with params" do
      it "hit Github url with correct header, params and returns correct response" do
        endpoint = "on/some/random/endpoint"
        method = "GET"
        opts = {
          per_page: 30,
          page: 1
        }
        request_headers = headers

        # Stub request
        stub_request(:get, "https://api.github.com/#{endpoint}").with(query: opts)

        git = Git::Session.new
        git.do_request(endpoint: endpoint, method: method, headers: request_headers, opts: opts)

        expect(WebMock).to have_requested(:get, "https://api.github.com/#{endpoint}").with(query: opts, headers: request_headers)
      end
    end
  end

  describe "POST on/some/resource" do
    context "when requested with valid body" do
      it "hit Github url with correct header, params and get successful response" do
        endpoint = "on/some/resource"
        method = "POST"
        request_body = {
          name: "random_name"
        }
        request_headers = headers

        expected_response_body = {
          message: "Resource updated successfully"
        }

        # Stub request
        stub_request(:post, "https://api.github.com/#{endpoint}").to_return(body: expected_response_body.to_json)

        git = Git::Session.new
        response = git.do_request(endpoint: endpoint, method: method, headers: request_headers, body: request_body)

        expect(WebMock).to have_requested(:post, "https://api.github.com/#{endpoint}").with(headers: request_headers)
        expect(response.read_body).to eq(expected_response_body.to_json)
      end
    end

    context "when requested with invalid body" do
      it "hit Github url with correct header, params and get unprocessable response" do
        endpoint = "on/some/random/endpoint"
        method = "POST"
        opts = {
          per_page: 30,
          page: 1
        }
        request_headers = headers

        expected_response_body = {
          message: "Invalid request body"
        }

        # Stub request
        stub_request(:post, "https://api.github.com/#{endpoint}")
          .with(query: opts)
          .to_return(body: expected_response_body.to_json, status: 422, headers: request_headers)

        git = Git::Session.new
        response = git.do_request(endpoint: endpoint, method: method, headers: request_headers, opts: opts)

        expect(WebMock).to have_requested(:post, "https://api.github.com/#{endpoint}").with(query: opts, headers: request_headers)
        expect(response.read_body).to eq(expected_response_body.to_json)
        expect(response.code.to_i).to eq(422)
      end
    end
  end
end
