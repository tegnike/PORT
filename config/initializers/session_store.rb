server = (
  if Rails.env.production?
    ENV["REDIS_URL"]
  elsif Rails.env.development?
    [{ host: "redis", port: 6379, db: 0, namespace: "session" }]
  else
    [{ host: "redis", port: 6379, db: 1, namespace: "session" }]
  end
)

App::Application.config.session_store :redis_store,
  servers: server,
  expire_after: 1.week,
  key: "_#{Rails.application.class.parent_name.downcase}_session"
