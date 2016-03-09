require 'resque-scheduler'
require 'resque/scheduler/server'

uri = URI.parse("redis://localhost:6379/")
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
Resque::Plugins::Status::Hash.expire_in = (24 * 60 * 60) # 24hrs in seconds

Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }

module Resque
  def self.search_delayed(n, v)
    arr_delayed = Resque.delayed_queue_peek(0, 20000).map do |ts|
      hash = Resque.delayed_timestamp_peek(ts, 0, 1).first
      hash[:ts] = ts
      hash
    end
    find = arr_delayed.select { |h| h["args"][0][n] == v }.first
    result = find.present? ? find : {}
    result.symbolize_keys
  end

  def self.remove_delayed(hash)
    Resque.remove_delayed_job_from_timestamp(hash[:ts], hash[:class].constantize, hash[:args][0])
  end
end