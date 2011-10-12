# encoding: utf-8

require 'action_view'
require 'action_controller'
require 'i18n/screwdriver/scanner'

module I18n
  module Screwdriver
    def self.included(klass)
      klass.send :include, InstanceMethods
    end
    
    module InstanceMethods
      def _(translation)
        # the . is a special character in rails i18n - we have to strip it
        translation_without_dot = translation.gsub(/\./, '').strip
        translated = I18n.translate(translation_without_dot)
        
        if defined?(Rails) && Rails.env.development? && translated.start_with?('translation missing')
          # TODO: add translation with key to all translation files
          #       so that rake task is obsolete - instant feedback!
        end
        
        translated
      end
    end
  end
end

ActionView::Base.send :include, I18n::Screwdriver
ActionController::Base.send :include, I18n::Screwdriver
ActionController::IntegrationTest.send :include, I18n::Screwdriver
ActionController::TestCase.send :include, I18n::Screwdriver