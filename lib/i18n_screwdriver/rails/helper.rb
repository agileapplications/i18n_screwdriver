module I18nScrewdriver
  module Rails
    module Helper
      def self.included(klass)
        klass.send :include, InstanceMethods
      end

      module InstanceMethods
        def _(text, options = {})
          I18n.translate(I18nScrewdriver.for_key(text), options)
        end
      end
    end
  end
end

ActionView::Base.send :include, I18nScrewdriver::Rails::Helper
ActionController::Base.send :include, I18nScrewdriver::Rails::Helper
ActionController::IntegrationTest.send :include, I18nScrewdriver::Rails::Helper
ActionController::TestCase.send :include, I18nScrewdriver::Rails::Helper

