# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "i18n_screwdriver"
  s.version     = "0.4.0"
  s.authors     = ["Tobias Miesel"]
  s.email       = ["agileapplications@gmail.com"]
  s.homepage    = "http://github.com/agileapplications/i18n_screwdriver"
  s.summary     = %q{make translating with rails i18n fun again}
  s.description = %q{make translating with rails i18n fun again}

  s.rubyforge_project = "i18n_screwdriver"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency 'activesupport', '>= 3.0.0'
  s.add_dependency 'actionpack', '>= 3.0.0'
  s.add_dependency 'i18n'
  
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'actionpack', '>= 3.0.0'
end
