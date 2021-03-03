# frozen_string_literal: true

module Git
  class Session < ExternalApi::Base
    def initialize
      # TODO: Should we hardcode this URL?
      super(base_url: "https://api.github.com")
    end
  end
end
