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

  def self.test_user_price
    billing_price.test_user_price
  end

  def self.build(params)
    sub = new(find_params(params))

    user = User.find_or_build_create params
    user.director = true if params[:type_account] == "company"

    if user.director? && user.company.blank?
      company = Company.build_create({name: params[:company_name], phone: params[:company_phone]})
      user.update(company: company, corporate: true)
    end

    sub_model = user.director? ? (user.company rescue user) : user
    current_sub = user.find_subscription

    sub.update({user_count: params[:user_count].to_i,
                subscriptiontable_type: sub_model.class.to_s,
                subscriptiontable_id: sub_model.id, active: false,

                note: "Тип аккаунта: #{params[:type_account]}. Кол-во пользователей: #{params[:user_count]}. " +
                  "Кол-во месяцев: #{params[:count_month]}. " +
                  "Тип подписки: #{params[:type_order]}"}.merge(up_date(current_sub, params[:type_order], sub_model.class))
    )
    sub
  end

  def self.current_time_day
    Time.now.beginning_of_day
  end

  def self.up_date(curr_sub, params_type, sub_model)

    date_to_type = date_to?(params_type.present? ? params_type : sub_model)
    if curr_sub.present?
      {date_from: curr_sub.date_from, date_to: curr_sub.date_to + date_to_type}
    else
      {date_from: current_time_day, date_to: current_time_day + date_to_type}
    end
  end

  def self.date_to?(type_order)
    {
      company: 1.month,
      user: 1.month,
      test_user: 1.day
    }[type_order.to_s.downcase.to_sym]
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

  # def residue_price
  #   reside_day = (((date_to.end_of_day - Time.now.end_of_day).abs / 60)/(24*60)).round
  #   all_day = (((date_from.end_of_day - date_to.end_of_day).abs / 60)/(24*60)).round
  #   ((all_day > 0 && self.sum > 0 && reside_day > 0) ? (((self.sum / all_day) * reside_day) rescue 0) : 0).round
  # end

  # def residue_month
  #   diff = date_to.month - Time.now.month
  #   diff > 0 ? diff.abs : 0
  # end

  # def residue_month
  #   a = date_to
  #   b = Time.now
  #   difference = 0.0
  #   if a.year != b.year
  #     difference += 12 * (b.year - a.year)
  #   end
  #   (difference + b.month - a.month).abs.round
  # end
  #
  # def residue_day
  #   (((date_to.end_of_day - Time.current.end_of_day).abs/ 60)/(24*60)).round
  # end

  # def self.default_all_month_and_price(type)
  #   arr_hash = []
  #   month_price_sum = default_price(type)
  #   12.times do |i|
  #     n = i + 1
  #     arr_hash << {
  #       month: "#{HELPERS.rus_case(n, 'месяц', 'месяца', 'месяцев')}",
  #       price: (month_price_sum*n)
  #     }
  #   end
  #   arr_hash
  # end

  # def all_month_and_price
  #   arr_hash = []
  #   month_price_sum = company? ? (self.class.company_price_user*user_count) : self.class.user_price
  #   12.times do |i|
  #     n = i + 1
  #     arr_hash << {
  #       month: "#{HELPERS.rus_case(n, 'месяц', 'месяца', 'месяцев')}",
  #       price: (month_price_sum*n) - residue_price
  #     }
  #   end
  #
  #   residue_month.times.map { |i| arr_hash.delete_at(0) } if residue_month > 0
  #   arr_hash
  # end

  def self.default_config(type)
    {
      date: "1 месяц", n: 1,
      user_company_price: company_price_user,
      default_price: default_price(type),
      #all_months: default_all_month_and_price(type),
      count_users: 1
    }
  end

  def self.default_price(type)
    {
      company: (company_price + company_price_user),
      user: user_price,
      test_user: test_user_price
    }[type.to_sym]
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
      date: HELPERS.ltime(date_to + 1.month, '', 'short_min_y'), n: 0,
      #all_months: all_month_and_price,
      default_price: default_price,
      count_users: user_count,
      day_of_month: Time.now.end_of_month.day,
      residue_of_month: Time.now.end_of_month.day - Time.now.day,
      user_company_price: self.class.company_price_user
    }
  end

  def default_price
    subscriptiontable_type == "User" ? Subscription.user_price : Subscription.company_price_user * user_count
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