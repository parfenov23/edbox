class User < ActiveRecord::Base
  belongs_to :company
  belongs_to :group
  has_many :bunch_groups
  before_create :create_hash_key
  after_create :welcome_letter
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
        user.transfer_to_json
      end
    end
  end

  def build_default(company_id, email)
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
    @password = BCrypt::Password.create(new_password)
    self.password_digest = @password
  end

  def create_hash_key
    self.user_key = SecureRandom.hex(20)
  end

  def welcome_letter
    return "Метод для отправки приветсвенного сообщения"
  end
end
