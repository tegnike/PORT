uri = Rails.env.production? ? URI.parse(ENV["REDIS_URL"]) : URI.parse("redis://redis:6379")
REDIS = Redis.new(host: uri.host, port: uri.port)
