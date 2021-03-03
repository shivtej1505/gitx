# frozen_string_literal: true

FactoryBot.define do
  factory :endpoint, class: Hash do
    initialize_with do
      nesting_level = attributes[:nesting_level] || 4
      Faker::Lorem.words(number: nesting_level).join("/")
    end
  end
end
