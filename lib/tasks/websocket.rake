namespace :websocket do
  desc 'Start the WebsocketRails standalone server.'
  task :start_server, [:port, :pid, :log] do |t, args|
    begin
      require "thin"
      load "#{Rails.root}/config/initializers/websocket_rails.rb"
      load "#{Rails.root}/config/events.rb"

      options = WebsocketRails.config.thin_options.merge(args)
      options[:port] = args[:port]

      warn_if_standalone_not_enabled!

      if options[:daemonize]
        fork do
          Thin::Controllers::Controller.new(options).start
        end
      else
        Thin::Controllers::Controller.new(options).start
      end

      puts "Websocket Rails Standalone Server listening on port #{options[:port]}"
    rescue
      puts "Fail!"
    end
  end

  desc 'Stop the WebsocketRails standalone server.'
  task :stop_server, [:port, :pid, :log] do |t, args|
    begin
      Fiber.new{
        require "thin"
        load "#{Rails.root}/config/initializers/websocket_rails.rb"
        load "#{Rails.root}/config/events.rb"

        options = WebsocketRails.config.thin_options.merge(args)
        options[:port] = args[:port]
        warn_if_standalone_not_enabled!

        Thin::Controllers::Controller.new(options).stop
      }.resume
    rescue
      puts "Fail!"
    end
  end
end

def warn_if_standalone_not_enabled!
  return if WebsocketRails.standalone?
  puts "Fail!"
  puts "You must enable standalone mode in your websocket_rails.rb initializer to use the standalone server."
  exit 1
end