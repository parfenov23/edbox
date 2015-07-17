class User < ActiveRecord::Base
  belongs_to :company
  belongs_to :group
  has_many :bunch_groups, dependent: :destroy
  has_many :favorite_courses, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_many :bunch_courses, dependent: :destroy
  has_many :test_results, dependent: :destroy
  has_many :account_type_relations, :as => :modelable, :dependent => :destroy
  before_create :create_hash_key
  validates :email, presence: true
  scope :leading, -> { where(leading: true) }
  EXCEPT_ATTR = ["password_digest", "created_at", "updated_at"]

  def self.build(params)
    params[:first_name] = "Пользователь" if params[:first_name].to_s == ""
    user = new(params)
    user.password = params[:password]
    user.welcome_letter(params[:password])
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

  def get_real_account_type
    account_type_relations.last.account_type
  end

  def get_account_type
    if corporate?
      company.get_account_type
    else
      get_real_account_type
    end
  end

  def update_account_type(account_type_id)
    unless account_type_id == (get_real_account_type.id rescue nil)
      AccountTypeRelation.new({modelable_type: "User", modelable_id: id, account_type_id: account_type_id}).save
    end
  end

  def all_groups
    company.groups
  end

  def my_groups
    ids_group = bunch_groups.map{|bg| bg.group_id}
    company.groups.where(id: ids_group)
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

  def self.time_zone
    timezone = "Asia/Yekaterinburg"
    TZInfo::Timezone.get(timezone).current_period.utc_offset / (60*60)
  end

  def full_name
    first_name.to_s + " " + last_name.to_s
  end

  def welcome_letter(new_password)
    HomeMailer.welcome_latter(self, new_password).deliver
  end

  private

  def create_hash_key
    self.user_key = SecureRandom.hex(20)
  end

end
