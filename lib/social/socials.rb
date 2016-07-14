require 'social/vk'
require 'social/fb'
class Socials
  def self.info(type, params)
    type.capitalize.constantize.info(params) rescue {}
  end

  def self.reg_params(type, params)
    type.capitalize.constantize.reg_params(info(type, params)) rescue {}
  end

  def self.auth_url(type)
    type.capitalize.constantize.auth_url rescue "#"
  end
end