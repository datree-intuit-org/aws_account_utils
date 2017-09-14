require 'aws_account_utils/base'
require 'watir-webdriver'
Watir::HTMLElement.attributes << :ng_model
Watir::HTMLElement.attributes << :ng_click
Watir::HTMLElement.attributes << :ng_class

module AwsAccountUtils
  class WatirBrowser
    attr_reader :logger

    def initialize(logger)
      @logger  = logger
    end

    def create
      logger.debug "Launching new browser."
      Watir::Browser.new(:firefox, :profile => set_firefox_profile)
    end

    private
    def set_firefox_profile
      profile = Selenium::WebDriver::Firefox::Profile.new

      if proxy
        proxy_settings.each do |k,v|
          profile["network.proxy.#{k}"] = v
        end
      end

      profile['browser.privatebrowsing.dont_prompt_on_enter'] = true
      profile['browser.privatebrowsing.autostart'] = true
      profile.native_events = false
      profile
    end

    def proxy_settings
      {
          'http'          => proxy,
          'http_port'     => proxy_port,
          'ssl'           => proxy,
          'ssl_port'      => proxy_port,
          'no_proxies_on' => '127.0.0.1',
          'type'          => 1
      }
    end

    def proxy
      @proxy ||= ENV['AWS_ACCOUNT_UTILS_HTTP_PROXY']
    end

    def proxy_port
      @proxy_port ||= ENV['AWS_ACCOUNT_UTILS_HTTP_PROXY_PORT']
    end
  end
end