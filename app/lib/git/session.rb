module Git
  class Session < ExternalApi::Base
    def initialize
      super(base_url: "https://api.github.com", use_ssl: true)
    end
  end
end
