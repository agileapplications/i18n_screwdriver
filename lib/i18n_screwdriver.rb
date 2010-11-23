module I18n
  module Screwdriver
    def self.included(klass)
      klass.send :include, InstanceMethods
    end
    
    module InstanceMethods
      def _(translation)
        # the . is a special character in rails i18n - we have to strip it
        translation_without_dot = translation.gsub(/\./, '').strip
        t("#{translation_without_dot}")
      end
    end
  end
end

ActionView::Base.send :include, I18n::Screwdriver
ActionController::Base.send :include, I18n::Screwdriver
