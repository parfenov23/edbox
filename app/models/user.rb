class User < ActiveRecord::Base
  belongs_to :company
  belongs_to :group
  has_many :bunch_groups, dependent: :destroy
  has_many :favorite_courses, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_many :bunch_courses, dependent: :destroy
  has_many :test_results, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :subscriptions, as: :subscriptiontable, dependent: :destroy
  has_many :user_webinars, dependent: :destroy
  has_many :incoming_moneys, dependent: :destroy
  has_many :ligament_leads, dependent: :destroy
  has_many :accounts, dependent: :destroy
  serialize :social, ActiveRecord::Coders::Hstore

  before_create :create_hash_key
  validates :email, presence: true
  scope :leading, -> { where(leading: true) }
  scope :statistics, ->(course) { all.map { |user| user.statistic(course) } }
  EXCEPT_ATTR = ["password_digest", "created_at", "updated_at", "group_id"]

  def self.build(params)
    params[:first_name] = "Пользователь" if params[:first_name].to_s == ""
    user = new(params)
    user.password = (params[:password].present? ? params[:password] : SecureRandom.hex(8))
    user.welcome_letter(params[:password])
    user
  end

  def self.auth(params)
    user = find_by_email(params[:email].downcase)
    unless user.nil?
      if user.password == params[:password]
        user.update_user_key
        user.assign_last_auth.transfer_to_json
      end
    end
  end

  def update_user_key
    self.update(user_key: SecureRandom.hex(20))
  end

  def self.build_default(company_id, email)
    User.build(
      {
        email: email,
        first_name: "Пользователь",
        director: false,
        corporate: true,
        company_id: company_id,
        password: SecureRandom.hex(8)
      }
    )
  end

  def random_password
    new_pass = SecureRandom.hex(8)
    self.password = new_pass
    save
    HomeMailer.change_password(self, new_pass).deliver
  end

  def transfer_to_json
    result = as_json(:except => EXCEPT_ATTR)
    result
  end

  def find_subscription(active = true, find_time=true, type="last")
    model = director? ? (company rescue self) : (corporate? ? (company rescue self) : self)
    time = Time.current
    subs = model.subscriptions.where(active: active) rescue nil
    if subs.present?
      if find_time
        subs = subs.where(["date_from < ? and date_to > ?", time, time])
      end
      type == "last" ? subs.last : subs
    end
  end

  def get_account_type
    find_subscription.present?
  end

  def get_account_type_name
    account_type_name = ''
    account_type_name += (get_account_type ? 'Платная' : 'Беcплатная')
    account_type_name += (corporate? ? ' корпоративная' : ' индивидуальная')
    account_type_name += ' подписка'
    account_type_name
  end

  def view_course?(course)
    !course.paid || (course.paid && get_account_type)
  end

  def all_groups
    company.groups
  end

  def my_groups
    ids_group = bunch_groups.map { |bg| bg.group_id }
    company.groups.where(id: ids_group)
  end

  def schedule
    bunch_courses_and_sections = bunch_courses.joins(:bunch_sections)
    all_dates = bunch_courses_and_sections.pluck(:date_complete, "bunch_sections.date_complete").flatten.uniq.compact
    arr_schedule = all_dates.map do |date|
      bunch_courses = bunch_courses_and_sections.where({date_complete: date}).uniq
      bunch_sections_ids = bunch_courses_and_sections
                             .where(bunch_sections: {date_complete: date})
                             .pluck("bunch_sections.id").uniq

      {date: date, bunch_courses: bunch_courses.ids, bunch_sections: bunch_sections_ids}
    end
    arr_schedule
  end

  def password
    @password ||= BCrypt::Password.new(password_digest)
  rescue BCrypt::Errors::InvalidHash
    @password = nil
  end

  def password=(new_password)
    password = BCrypt::Password.create(new_password)
    self.password_digest = password
  end

  def assign_last_auth
    self.last_auth = Time.now
    save
    self
  end

  def auth?
    (last_auth > created_at ? true : false) rescue false
  end

  def self.user_zone
    "Europe/Moscow"
  end

  def self.time_zone
    timezone = user_zone
    TZInfo::Timezone.get(timezone).current_period.utc_offset / (60*60)
  end

  def full_name
    user_name = first_name.to_s + " " + last_name.to_s
    user_name.gsub(" Пользователь", "").gsub("Пользователь ", "")
  end

  def name
    first_name.to_s + " " + last_name.to_s
  end

  def welcome_letter(new_password)
    HomeMailer.welcome_latter(self, new_password).deliver
    EmailNotif.all.each do |email_notif|
      HomeMailer.email_notifs(email_notif.email, self).deliver
    end
  end

  def create_notify(model, type=nil, repeat=false)
    notifications.find_or_create_by({user_id: id, notifytable_type: model.class.to_s, notifytable_id: model.id, action_type: type}) unless repeat
    notifications.create({user_id: id, notifytable_type: model.class.to_s, notifytable_id: model.id, action_type: type}) if repeat
  end

  def notify_json(type=nil)
    {}
  end

  def statistic(course)
    status = course.first_webinar.user_webinars.where(user_id: id).last.date_entry rescue nil
    {id: id, course: status}
  end

  def auth_url(params = {})
    params[:key] = user_key
    "#{$env_mode.current_domain}/auth_user?" + params.map { |k, v| "#{k}=#{CGI.escape(v)}" }.join("&")
  end

  def no_read_news
    News.where.not("#{id} = ANY (users_id)")
  end

  def read_news
    News.where("#{id} = ANY (users_id)")
  end

  def self.payments_account
    users = User.select { |u| !u.get_account_type && u.subscriptions.present? }
    users = User.find(
      users.map do |u|
        u.subscription_model.subscriptions.last.parent_user.id
      end.uniq
    )
    users.each do |user|
      sub_model = user.subscription_model
      params_sub = {
        user_id: user.id,
        sum: sub_model.sub_price_month,
        user_count: sub_model.sub_count_user,
        count_month: 1,
        email: user.email,
        type_account: sub_model.class == Company ? "company" : "user"
      }
      subscription = Subscription.build(params_sub)
      account = user.accounts.last
      if account.present?
        response = $cloud_payments.gateway.purchase(account.token, params_sub[:sum], $cloud_payments.default_options(user), false)
        if response.success?
          subscription.save
          user.sub_active(subscription)
        end
      end
    end
  end

  def sub_price_month
    Subscription.user_price
  end

  def sub_count_user
    0
  end

  def subscription_model
    company.present? ? company : self
  end

  def sub_active(sub)
    all_subs = find_subscription([true, false], false, false)
    if all_subs.present?
      all_subs.update_all(active: false)
      all_subs.where(id: sub.id).update_all(active: true)
    end
  end

  private

  def create_hash_key
    self.user_key = SecureRandom.hex(20)
  end

end
