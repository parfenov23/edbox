class User < ActiveRecord::Base
  belongs_to :company
  belongs_to :group
  has_many :bunch_groups, dependent: :destroy
  has_many :favorite_courses, dependent: :destroy
  before_create :create_hash_key, :welcome_letter, :hash_password
  validates :email, presence: true
  EXCEPT_ATTR = ["password_digest", "created_at", "updated_at"]

  def self.build(params)
    params[:first_name] = "Пользователь" if params[:first_name].to_s == ""
    user = new(params)
    user.password = params[:password]
    user
  end

  def self.auth(params)
    user = find_by_email(params[:email])
    unless user.nil?
      if user.password == params[:password]
        user.assign_last_auth.transfer_to_json
      end
    end
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

  def transfer_to_json
    result = as_json(:except => EXCEPT_ATTR)
    result
  end

  def all_groups
    company.groups
  end

  def password
    @password ||= BCrypt::Password.new(password_digest)
  rescue BCrypt::Errors::InvalidHash
    @password = nil
  end

  def password=(new_password)
    self.password_digest = new_password
  end

  def assign_last_auth
    self.last_auth = Time.now
    save
    self
  end

  def auth?
    (last_auth > created_at ? true : false) rescue false
  end

  def self.time_zone
    timezone = "Asia/Yekaterinburg"
    TZInfo::Timezone.get(timezone).current_period.utc_offset / (60*60)
  end

  private

  def create_hash_key
    self.user_key = SecureRandom.hex(20)
  end

  def welcome_letter
    HomeMailer.welcome_latter(self).deliver
  end

  def hash_password
    self.password_digest = BCrypt::Password.create(self.password_digest)
  end

end
