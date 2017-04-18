module ApiClients
  class TelegramCli
    require 'singleton'
    require 'yaml'

    TG_CONFIG = YAML.load_file(File.expand_path("#{Rails.root.to_s}/config/telegram.yml", __FILE__))

    def send_message(message)
      all_config = "#{TG_CONFIG['telegram_path']} -k #{TG_CONFIG['key_path']} -W -e"
      peer = "#{TG_CONFIG['peer']}"
      system('#{all_config} "msg #{peer} \"#{message}\" "')
    end
  end
end