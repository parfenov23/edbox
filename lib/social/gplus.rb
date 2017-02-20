class Gplus
  def self.info(params)
    agent = Mechanize.new
    agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    page = agent.get("#{api_url}userinfo?access_token=#{params[:access_token]}")
    hash_json = JSON.parse(page.body.force_encoding("UTF-8")).inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    slice_params(params).merge(hash_json).merge({type: 'gplus'})
  end

  def self.reg_params(params)
    email = params[:email].present? ? params[:email] : "gp#{params[:id]}@google.com"
    params[:email] = email
    params[:first_name] = params[:name].split(" ").first
    params[:last_name] = params[:name].split(" ").last
    params[:password] =  SecureRandom.hex(8)
    params[:avatar] = params[:picture]
    # params[:social] = {gplus: "https://www.facebook.com/#{params[:id]}"}
    params
  end

  def self.auth_url
    scope = "https://www.googleapis.com/auth/userinfo.email%20https://www.googleapis.com/auth/userinfo.profile"
    "https://accounts.google.com/o/oauth2/auth?redirect_uri=#{$env_mode.current_domain}/sign_up?type=gplus&response_type=code&client_id=#{app_id}&scope=#{scope}"
  end

  def self.app_id
    "236495690535-1krdbhsd3om074f1c00mdlvk6kd9qbq1.apps.googleusercontent.com"
  end

  def self.secret_key
    "1iQjT7n81Bo4K8aM-Un0JNa9"
  end

  private

  def self.api_url
    "https://www.googleapis.com/oauth2/v1/"
  end

  def self.inputs_info
    "id,name,picture,email"
  end

  def self.slice_params(params)
    params.slice(:access_token, :email, :id).compact.select { |k, v| v.present? } rescue {}
  end

end