# frozen_string_literal: true

FactoryBot.define do
  factory :headers, class: Hash do
    defaults = {
      "Authorization": "token #{Faker::Lorem.characters(number: 40)}",
      "Accept": "application/vnd.github.v3+json"
    }

    initialize_with { defaults.merge(attributes) }

    factory :headers_with_auth_token
  end

  factory :headers_without_auth_token, class: Hash do
    defaults = {
      "Accept": "application/vnd.github.v3+json"
    }

    initialize_with { defaults.merge(attributes) }
  end
end
