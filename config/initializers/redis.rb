if Rails.env.production?
  uri = URI.parse(ENV["REDIS_URL"])
  REDIS = Redis.new(host: uri.host, port: uri.port)
elsif Rails.env.development?
  REDIS = Redis.new(host: "redis", port: 6379, db: 0)
else
  REDIS = Redis.new(host: "redis", port: 6379, db: 1)
end
