# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])

require 'rails/commands/server'

if Rails.env.development?

  module Rails
    class Server
      alias_method :default_options_alias, :default_options

      def default_options
        default_options_alias.merge!(:Host => '0.0.0.0', :Port => 4000)
      end
    end
  end

end

# if Rails.env.production?
#
#   begin
#     `RAILS_ENV=production bundle exec rake websocket_rails:stop_server`
#   rescue
#     p "Fail"
#   end
#   begin
#     `RAILS_ENV=production bundle exec rake websocket_rails:start_server`
#   rescue
#     p "Fail"
#   end
#
# end
