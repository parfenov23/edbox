class MailerWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  require 'sidekiq/api'

  def perform(*arg)
    params = arg.first
    case params["type"]
    when "soon_began_webinar"
      Webinar.soon_began_webinar(params["id"])
    end
  end

  #=========     helpers methods
  def self.all
    ss = Sidekiq::ScheduledSet.new
    ss.select {|retri| retri.klass == self.to_s }
  end

  def self.find_by_id(id)
    all.find {|h| h.jid == id}
  end

  def self.delete(id)
    find_job = find_by_id(id)
    find_job.delete if find_job.present?
  end

  def self.all_rs_clear
    rs = Sidekiq::RetrySet.new
    rs.clear
  end
  #=========
end
