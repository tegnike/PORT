REDIS ||= Redis.new(url: ENV["redis://redis:6379"] || "redis://localhost:6379")
