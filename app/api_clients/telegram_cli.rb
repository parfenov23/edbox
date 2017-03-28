module ApiClients
  class TelegramCli
    require 'singleton'
    require 'yaml'

    TG_CONFIG = YAML.load_file(File.expand_path("#{Rails.root.to_s}/config/telegram.yml", __FILE__))

    def send_message(message)
      system("#{TG_CONFIG['telegram_path']} -k #{TG_CONFIG['key_path']} -W -e 'msg #{TG_CONFIG['peer']} #{message}'")
    end
  end
end