# frozen_string_literal: true

FactoryBot.define do
  factory :status_code, class: Hash do
    initialize_with do
      # TODO: Find better way to store & read this list
      [100, 101, 102, 103, 200, 201, 202, 203, 204, 205, 206, 207, 300, 301, 302, 303, 304, 305, 306, 307, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 422, 423, 424, 425, 426, 449, 450, 500, 501, 502, 503, 504, 505, 506, 507, 509, 510].sample
    end
  end
end
