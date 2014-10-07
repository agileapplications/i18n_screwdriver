namespace :i18n do
  desc 'Find all translations in views, helpers and controllers'
  task :update => :environment do
    translations = I18nScrewdriver.gather_translations("**/*.{haml,erb,slim,rb}")
    I18nScrewdriver.write_translations(default_locale, translations)
    puts "Found #{translations.keys.size} unique translations"
  end

  desc 'Write dummy translation files so they can manually be translated'
  task :update_foreign => :environment do
    # load translations from default locale
    translations = I18nScrewdriver.load_translations(default_locale)

    # process each language we'd like to translate
    (available_locales - [default_locale]).each do |locale|
      filename = I18nScrewdriver.filename(locale)

      # load existing translations
      existing_translations = File.exists?(filename) ? I18nScrewdriver.load_translations(locale) : {}

      # delete removed translations from hash
      existing_translations.reject!{ |k| !translations.has_key?(k) }

      # add new translations
      translations.each_key{ |k| existing_translations[k] ||= dummy_text }

      # write the file
      I18nScrewdriver.write_translations(locale, existing_translations)
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
