module Git
  class Session < ExternalApi::Base
    def initialize
      super(base_url: "https://api.github.com")
    end
  end
end
