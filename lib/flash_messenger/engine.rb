require 'flash_messenger/messenger'

module FlashMessenger
  class Engine < ::Rails::Engine
    isolate_namespace ::FlashMessenger

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

    initializer 'flash_messenger.default_locale' do |app|
      app.config.tap do |c|
        default_locale = \
          c.try(:flash_messenger).try(:default_locale) ||
          c.try(:i18n).try(:default_locale) ||
          :en

        ::FlashMessenger::DEFAULT_LOCALE = default_locale
      end
    end
  end
end
