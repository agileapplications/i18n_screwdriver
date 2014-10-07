namespace :i18n do
  desc 'Find all translations in views, helpers and controllers'
  task :update => :environment do
    translations = I18nScrewdriver.gather_translations
    puts "Found #{translations.keys.size} unique translations"
    I18nScrewdriver.available_locales.each do |locale|
      I18nScrewdriver.update_translations_file(locale, translations)
    end
  end

  desc 'Translate all not yet translated texts for a given locale'
  task :translate => :environment do
    raise "ERROR: usage: TRANSLATE=de rake i18n:translate" unless ENV['TRANSLATE']
    locale = ENV['TRANSLATE']

    texts = I18nScrewdriver.load_translations(default_locale)
    translations = I18nScrewdriver.load_translations(locale)
    puts "Translating #{translations.keys.size} entries from <#{default_locale}> to <#{locale}> (enter :q to save and quit, ctrl-c to abort):"
    translations.keys.sort.each do |key|
      next unless [dummy_text, "", nil].include?(translations[key])
      puts "> #{texts[key]}"
      input = STDIN.gets.chomp
      break if input == ":q"
      translations[key] = input
    end

    puts "Saving translations..."
    I18nScrewdriver.write_translations(locale, translations)
  end
end
