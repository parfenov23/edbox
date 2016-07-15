class Vk
  def self.info(params)
    agent = Mechanize.new
    page = agent.get("#{api_url}users.get?access_token=#{params[:access_token]}&fields=#{inputs_info}")
    hash_vk = JSON.parse(page.body.force_encoding("UTF-8"))["response"].first.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    vk_params(params).merge(hash_vk).merge({type: 'vk'})
  end

  def self.reg_params(params)
    email = params[:email].present? ? params[:email] : "vk#{params[:uid]}@vkmessenger.com"
    params[:email] = email
    params[:password] =  SecureRandom.hex(8)
    params[:avatar] = params[:photo_max_orig]
    params[:social] = {vk: "http://vk.com/id#{params[:uid]}"}
    params
  end

  def self.auth_url
    "https://oauth.vk.com/authorize?client_id=#{app_id}&display=page&redirect_uri=#{$env_mode.current_domain}/sign_up?type=vk&scope=email,offline&response_type=token&v=5.52"
  end

  private

  def self.api_url
    "https://api.vk.com/method/"
  end

  def self.inputs_info
    "photo_max_orig,city,verified,contacts,email"
  end

  def self.vk_params(params)
    params.slice(:access_token, :email, :user_id).compact.select { |k, v| v.present? } rescue {}
  end

  def self.app_id
    $env_mode.dev? ? '5545746' : ($env_mode.beta? ? '5546100' : '5545731')
  end

end