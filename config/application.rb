require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'rack/fiber_pool'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Edbox
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.i18n.available_locales = ["en", "ru"]
    config.i18n.default_locale = :ru
    config.exceptions_app = self.routes

    # config.active_record.whitelist_attributes = true
    config.cache_store = :redis_store, 'redis://127.0.0.1:6379/0/cache', { expires_in: 90.minutes }
    # config.middleware.insert_before(ActiveRecord::ConnectionAdapters::ConnectionManagement, Rack::FiberPool)
    # config.threadsafe!
    # config.time_zone = 'Asia/Yekaterinburg'
    # config.active_record.default_timezone = :local
    config.time_zone = "UTC"
    config.active_record.default_timezone = :utc
    config.action_controller.page_cache_directory = "#{Rails.root.to_s}/public/deploy"
  end
end
