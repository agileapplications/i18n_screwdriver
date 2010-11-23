class ScrewdriverGenerator < Rails::Generators::NamedBase
  namespace "i18n"

  def generate_screwdriver
    copy_file "#{File.expand_path('../tasks', __FILE__)}/i18n.rake", "lib/tasks/#{file_name}.css"
  end
end