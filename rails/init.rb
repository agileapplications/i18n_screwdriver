require 'i18n_screwdriver'

ActionView::Base.send :include, I18n::Screwdriver
ActionController::Base.send :include, I18n::Screwdriver