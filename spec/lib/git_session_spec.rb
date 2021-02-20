require "rails_helper"

def request_params(only_post_kind: false)
  endpoint =  FactoryBot.build(:endpoint)
  if only_post_kind
    method = [:put, :post, :delete, :patch].sample
  else
    method = [:get, :put, :post, :delete, :patch].sample
  end
  request_headers = FactoryBot.build(:headers)
  [
    endpoint,
    method,
    request_headers
  ]
end

def stub_github_request(method, endpoint)
  stub_request(method, "https://api.github.com/#{endpoint}")
end

RSpec.describe Git::Session do
  describe "GET/PUT/POST/DELETE/PATCH on randomly generated endpoint" do
    1.upto(20) do
      context "when requested with randomly selected verb" do
        it "hit correct url with correct header" do
          # setup
          endpoint, method, request_headers = request_params
          stub_github_request(method, endpoint)

          # test
          git = Git::Session.new
          git.do_request(endpoint: endpoint, method: method, headers: request_headers)

          # except
          expect(WebMock).to have_requested(method, "https://api.github.com/#{endpoint}").with(headers: request_headers)
        end
      end

      context "when requested with randomly selected verb with params" do
        it "hit correct url with params" do
          # setup
          endpoint, method, request_headers = request_params
          opts = Faker::Types.rb_hash
          stub_github_request(method, endpoint).with(query: opts)

          # test
          git = Git::Session.new
          git.do_request(endpoint: endpoint, method: method, headers: request_headers, opts: opts)

          # except
          expect(WebMock).to have_requested(method, "https://api.github.com/#{endpoint}").with(query: opts, headers: request_headers)
        end
      end

      context "when requested with randomly selected verb with body" do
        it "hit correct url with correct body" do
          # setup
          endpoint, method, request_headers = request_params(only_post_kind: true)
          body = Faker::Types.rb_hash
          stub_github_request(method, endpoint).with(body: body)

          # test
          git = Git::Session.new
          git.do_request(endpoint: endpoint, method: method, headers: request_headers, body: body)

          # except
          expect(WebMock).to have_requested(method, "https://api.github.com/#{endpoint}")
                               .with(headers: request_headers, body: body)
        end
      end

      context "when requested with randomly selected verb" do
        it "hit correct url with correct header and return correct response & status" do
          # setup
          endpoint, method, request_headers = request_params
          expected_response_body = Faker::Types.rb_hash
          expected_status = FactoryBot.build(:status_code)

          stub_github_request(method, endpoint)
            .to_return(body: expected_response_body.to_json, status: expected_status, headers: request_headers)

          # test
          git = Git::Session.new
          response = git.do_request(endpoint: endpoint, method: method, headers: request_headers)

          # except
          expect(WebMock).to have_requested(method, "https://api.github.com/#{endpoint}").with(headers: request_headers)
          expect(response.read_body).to eq(expected_response_body.to_json)
          expect(response.code.to_i).to eq(expected_status)
        end
      end
    end
  end
end
