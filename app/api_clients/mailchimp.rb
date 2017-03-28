module ApiClients
  class Mailchimp

    def create_member(params)
      gibbon.lists(list_id).members.create(body: params)
    end

    private

    def gibbon
      Gibbon::Request.new(api_key: api_key)
    end

    def api_key
      $env_mode.dev? ? "291f75af7282d135145ac137972461b1-us15" : "7a916a96b9483261971e3367ea249f97-us14"
    end

    def list_id
      $env_mode.dev? ? "8b62384ddf" : "c47fe1d6e6"
    end
  end
end