class User < ActiveRecord::Base
  before_create :create_hash_key
  def self.build(params)
    new(params)
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
end
