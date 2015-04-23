namespace :i18n do
  desc 'Find all translations in views, helpers and controllers'
  task :update => :environment do
    translations = I18nScrewdriver.gather_translations
    puts "Found #{translations.keys.size} unique translations"
    default_locale = I18n.default_locale.to_s
    I18nScrewdriver.update_translations_file(default_locale, translations)
  end

  desc 'Translate all not yet translated texts for a given locale'
  task :translate => :environment do
    raise "ERROR: usage: TRANSLATE=de rake i18n:translate" unless ENV['TRANSLATE']
    locale = ENV['TRANSLATE']
    default_locale = I18n.default_locale.to_s

    texts = I18nScrewdriver.load_translations(default_locale)
    translations = {}
    begin
      translations = I18nScrewdriver.load_translations(locale)
    rescue I18nScrewdriver::Error => e
      puts "WARNING: #{e.message}"
    end

    puts "Translating #{translations.keys.size} entries from <#{default_locale}> to <#{locale}> (enter :q to save and quit, ctrl-c to abort):"
    texts.keys.sort.each do |key|
      next unless [I18nScrewdriver::DUMMY_TEXT, "", nil].include?(translations[key])
      puts "> #{texts[key]}"
      input = STDIN.gets.chomp
      break if input == ":q"
      translations[key] = input
    end

    puts "Saving translations..."
    I18nScrewdriver.write_translations(locale, translations)
  end
end
