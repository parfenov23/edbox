class EnvMode
  def initialize
    @mode = init_mode
    @config = init_config
  end

  def init_config
    Hash[YAML.load_file(Rails.root.join('config/config.yml'))[to_s].map{ |k, v| [k.to_sym, v] }]
  end

  def init_mode
    Rails.env.development? ? "development" : (Rails.root.to_s.scan("beta").present? ? "beta" : "production")
  end

  def dev?
    @mode == 'development'
  end

  def prod?
    @mode == 'production'
  end

  def beta?
    @mode == 'beta'
  end

  def current_domain
    domains = {
      development: "http://localhost:#{port}",
      beta: "http://betaed.masshtab.am",
      production: "http://adconsult.online"
    }
    domains[to_key]
  end

  def config
    @config
  end

  def port
    config[:port]
  end

  def name_title
    "ADCONSULT.ONLINE"
  end

  def to_s
    @mode
  end

  def to_key
    to_s.to_sym
  end
end

$env_mode = EnvMode.new