class ScrewdriverGenerator < Rails::Generators::Base
  def generate_screwdriver
    copy_file "#{File.expand_path('../../tasks', __FILE__)}/i18n.rake", "lib/tasks/i18n.rake"
  end
end