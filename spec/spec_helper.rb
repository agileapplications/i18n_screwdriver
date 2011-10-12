require 'rubygems'
require 'bundler/setup'

require 'i18n_screwdriver'

DEFAULT_LANGUAGE = 'de'
FOREIGN_LANGUAGES = ['en']

RSpec.configure do |config|

  config.include I18n::Screwdriver
    
end
