class Subscription < ActiveRecord::Base
  belongs_to :subscriptiontable, :polymorphic => true
  HELPERS = ApplicationController.helpers

  #BILLING_PRICE = BillingPrice.default

  def self.billing_price
    BillingPrice.default
  end

  def self.user_price
    billing_price.user_price
  end

  def self.company_price
    billing_price.company_price
  end

  def self.company_price_user
    billing_price.company_user_price
  end

  def self.build(params)
    sub = new(find_params(params))
    if params[:type] == "new_user"
      user = User.build({email: params[:email], password: SecureRandom.hex(6)})
      user.save
    else
      user = User.find(params[:user_id])
    end
    (params[:type_account] == "company" ? (user.director = true) : nil) if params[:type_account].present?
    if user.director? && user.company.blank?
      company = Company.build({name: params[:company_name], phone: params[:company_phone]})
      company.save
      user.company = company
      user.corporate = true
      user.save
    end
    sub.user_count = params[:user_count].to_i
    subscription_model = user.director? ? (user.company rescue user) : user
    sub.subscriptiontable_type = subscription_model.class.to_s
    sub.subscriptiontable_id = subscription_model.id
    sub.active = false
    current_sub = user.find_subscription
    date_from = current_sub.present? ? current_sub.date_from : Time.now.beginning_of_day
    sub.date_from = date_from
    if current_sub.present?
      date_to = params[:count_month].scan('месяц').present? ? (current_sub.date_to + params[:count_month].to_i.month) : current_sub.date_to
    else
      date_to = Time.now.beginning_of_day + params[:count_month].to_i.month
    end
    sub.date_to = date_to
    sub.note = "Тип аккаунта: #{params[:type_account]}. Кол-во пользователей: #{params[:user_count]}. " +
      "Кол-во месяцев: #{params[:count_month]}. " +
      "Тип подписки: #{params[:type_order]}"
    sub
  end

  def overdue?(day=0)
    (date_to.end_of_day - day.day - 1.hour) < Time.current.end_of_day
  end

  def user?
    subscriptiontable_type == "User"
  end

  def company?
    subscriptiontable_type == "Company"
  end

  def residue_price
    reside_day = (((date_to.end_of_day - Time.now.end_of_day).abs / 60)/(24*60)).round
    all_day = (((date_from.end_of_day - date_to.end_of_day).abs / 60)/(24*60)).round
    ((all_day > 0 && self.sum > 0 && reside_day > 0) ? (((self.sum / all_day) * reside_day) rescue 0) : 0).round
  end

  # def residue_month
  #   diff = date_to.month - Time.now.month
  #   diff > 0 ? diff.abs : 0
  # end

  def residue_month
    a = date_to
    b = Time.now
    difference = 0.0
    if a.year != b.year
      difference += 12 * (b.year - a.year)
    end
    (difference + b.month - a.month).abs.round
  end

  def residue_day
    (((date_to.end_of_day - Time.current.end_of_day).abs/ 60)/(24*60)).round
  end

  def self.default_all_month_and_price(type)
    arr_hash = []
    month_price_sum = (type == "company" ? (company_price + company_price_user) : user_price)
    12.times do |i|
      n = i + 1
      arr_hash << {
        month: "#{HELPERS.rus_case(n, 'месяц', 'месяца', 'месяцев')}",
        price: (month_price_sum*n)
      }
    end
    arr_hash
  end

  def all_month_and_price
    arr_hash = []
    month_price_sum = company? ? (self.class.company_price_user*user_count) : self.class.user_price
    12.times do |i|
      n = i + 1
      arr_hash << {
        month: "#{HELPERS.rus_case(n, 'месяц', 'месяца', 'месяцев')}",
        price: (month_price_sum*n) - residue_price
      }
    end

    residue_month.times.map { |i| arr_hash.delete_at(0) } if residue_month > 0
    arr_hash
  end

  def self.default_config(type)
    {
      date: "1 месяц", n: 1,
      user_company_price: company_price_user,
      default_price: (type == "company" ? (company_price + company_price_user) : user_price),
      all_months: default_all_month_and_price(type),
      count_users: 1
    }
  end

  def parent_user
    if user?
      self.subscriptiontable
    else
      self.subscriptiontable.users.find_by_director(true)
    end
  end

  def config
    {
      date: HELPERS.ltime(date_to, '', 'short_min_y'), n: 0,
      all_months: all_month_and_price,
      default_price: 0,
      count_users: user_count,
      user_company_price: self.class.company_price_user,
    }
  end

  def self.find_params(params)
    params = ActionController::Parameters.new(params) if params.class == Hash
    params.permit(:date_from, :date_to, :subscriptiontable_type, :sum,
                  :subscriptiontable_id, :active).compact.select { |k, v| v != "" } rescue {}
  end

  def date_string
    (date_from.strftime('%d.%m.%Y %H:%M') + " по " + date_to.strftime('%d.%m.%Y %H:%M')) rescue nil
  end
end