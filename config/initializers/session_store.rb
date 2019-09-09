if Rails.env.production?

  App::Application.config.session_store :redis_store,
    servers: ENV["REDIS_URL"],
    expire_after: 1.week,
    key: "_#{Rails.application.class.parent_name.downcase}_session"

else

  App::Application.config.session_store :redis_store,
    servers: [
      {
        host: "redis",
        port: 6379,
        db: 0,
        namespace: "session"
      },
    ],
    expire_after: 1.week,
    key: "_#{Rails.application.class.parent_name.downcase}_session"
end
