class Fb
  def self.info(params)
    agent = Mechanize.new
    page = agent.get("#{api_url}me?access_token=#{params[:access_token]}&fields=#{inputs_info}")
    hash_json = JSON.parse(page.body.force_encoding("UTF-8")).inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    slice_params(params).merge(hash_json).merge({type: 'fb'})
  end

  def self.reg_params(params)
    email = params[:email].present? ? params[:email] : "fb#{params[:id]}@facebook.com"
    params[:email] = email
    params[:first_name] = params[:name].split(" ").first
    params[:last_name] = params[:name].split(" ").last
    params[:password] =  SecureRandom.hex(8)
    params[:avatar] = params[:picture]["data"]["url"]
    params[:social] = {fb: "https://www.facebook.com/#{params[:id]}"}
    params
  end

  def self.auth_url
    "https://www.facebook.com/dialog/oauth?client_id=#{app_id}&redirect_uri=#{$env_mode.current_domain}/sign_up?type=fb&scope=email&response_type=token"
  end

  private

  def self.api_url
    "https://graph.facebook.com/"
  end

  def self.inputs_info
    "id,name,picture,email"
  end

  def self.slice_params(params)
    params.slice(:access_token, :email, :id).compact.select { |k, v| v.present? } rescue {}
  end

  def self.app_id
    "1718642978353463"
  end

end