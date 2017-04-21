# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "i18n_screwdriver/version"

Gem::Specification.new do |s|
  s.name        = "i18n_screwdriver"
  s.version     = I18nScrewdriver::VERSION
  s.license     = "MIT"
  s.authors     = ["Tobias Miesel", "Corin Langosch"]
  s.email       = ["agileapplications@gmail.com", "info@corinlangosch.com"]
  s.homepage    = "https://github.com/agileapplications/i18n_screwdriver"
  s.summary     = %q{make translating with rails i18n fun again}
  s.description = %q{make translating with rails i18n fun again}

  s.rubyforge_project = "i18n_screwdriver"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "byebug"
  s.add_runtime_dependency "rails", ">=3.0.0"
end

