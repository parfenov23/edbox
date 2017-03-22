class WebinarMailJob < Resque::JobWithStatus
  @queue = :webinar_mail

  def perform
    perform_start
    run_action
    perform_complete
  end

  def self.run(date_time, id)
    Resque.enqueue_at(date_time, self, webinar_id: id)
  end

  def self.remove(id)
    search_job = find(id)
    Resque.remove_delayed(search_job) if search_job.present?
  end

  def self.find(id)
    Resque.search_delayed('webinar_id', id)
  end

  private

  def run_action
    # webinar = Webinar.find(options["webinar_id"])
    # webinar.user_webinars.each do |user_webinar|
    #   user = user_webinar.user
    #   HomeMailer.soon_began_webinar(user, webinar).deliver
    # end
  end

  def perform_start
    at(0, 1, "0 - 1")
  end

  def perform_complete
    at(1, 1, "Complete")
  end
end