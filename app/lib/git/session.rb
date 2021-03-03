# frozen_string_literal: true

module Git
  class Session < ExternalApi::Base
    def initialize
      # Ideally, this base_url should be fetched from environment
      super(base_url: "https://api.github.com")
    end
  end
end
