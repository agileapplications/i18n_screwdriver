namespace :i18n do
  desc 'translate foreign language file line by line'
  task :translate => :environment do
    raise "ERROR: usage: TRANSLATE=de rake i18n:translate" unless ENV['TRANSLATE']
    language = ENV['TRANSLATE']
    if File.exists?("config/locales/application.#{language}.yml")
      existing_translations = YAML.load_file("config/locales/application.#{language}.yml")
      existing_translations = existing_translations[language]
      puts "Translating #{existing_translations.keys.size} entries to <#{language}> (enter :q to save and quit):"
      existing_translations.keys.sort.each do |key|
        if ["TRANSLATION_MISSING", ""].include?(existing_translations[key])
          puts "> #{key}"
          input = STDIN.gets.chomp
          if input == ":q"
            break
          else
            existing_translations[key] = input
          end
        end
      end
      
      puts "Schreiben der Datei config/locales/application.#{language}.yml"
      #write_translation_file(language, existing_translations)
    else
      puts "ERROR: No translation file in config/locales/application.#{language}.yml"
      puts "Choosen language is invalid or you did not run rake i18n:update yet"
    end
  end
end