FactoryBot.define do
  factory :headers, class: Hash do
    defaults = {
      "Authorization": "token #{Faker::Lorem.characters(number: 40)}",
      "Accept": "application/vnd.github.v3+json"
    }

    initialize_with { defaults.merge(attributes) }
  end
end
