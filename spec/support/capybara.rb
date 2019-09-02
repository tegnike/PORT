Capybara.default_driver    = :selenium_chrome
Capybara.javascript_driver = :selenium_chrome
Capybara.server_host = Socket.ip_address_list.detect { |addr| addr.ipv4_private? }.ip_address
Capybara.server_port = 3001

Capybara.register_driver :selenium_chrome do |app|
  url = "http://chrome:4444/wd/hub"
  Capybara::Selenium::Driver.new(app, desired_capabilities: :chrome, browser: :remote, url: url)
end
