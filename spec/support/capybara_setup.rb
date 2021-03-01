Capybara.default_max_wait_time = 2

Capybara.default_normalize_ws = true

Capybara.save_path = ENV.fetch('CAPYBARA_ARTIFACTS', './tmp/capybara')

Capybara.configure do |config|
  config.test_id = 'data-test'
  config.automatic_label_click = true
end

Capybara.singleton_class.prepend(Module.new do
  attr_accessor :last_used_session

  def using_session(name, &block)
    self.last_used_session = name
    super
  ensure
    self.last_used_session = nil
  end
end)

Capybara.add_selector(:test_id) do
  css { |value| "[data-test-id='#{value}']" }
end

Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  [
    'headless',
    'window-size=1200x1200',
    'disable-gpu' # https://developers.google.com/web/updates/2017/04/headless-chrome
  ].each { |arg| options.add_argument(arg) }

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end
