require "bundler/setup"
Bundler.setup

require 'byebug'
require "i18n_screwdriver"

%w[en it].each {|locale| I18n.load_path << File.expand_path("../locales/#{locale}.yml", __FILE__) }

RSpec.configure do |config|
  # some (optional) config here
end
