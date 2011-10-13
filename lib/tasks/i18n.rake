namespace :i18n do
  desc 'Find all translations in views, helpers and controllers'
  task :update => :environment do
    raise "Please set I18.default_locale" unless I18n.default_locale.present?
    default_locale = I18n.default_locale.to_s

    raise "Please set I18.available_locales" unless I18n.available_locales.count > 0
    available_locales = I18n.available_locales.map(&:to_s)

    # parse all view files for texts to be translated
    texts = []
    Dir.glob("**/*.{haml,erb,slim}").each do |file|
      texts.concat(I18nScrewdriver.grab_texts_to_be_translated(File.read(file)))
    end

    # also check helper files and controllers
    Dir.glob("**/*{_helper,_controller}.rb").each do |file|
      texts.concat(I18nScrewdriver.grab_texts_to_be_translated(File.read(file)))
    end

    # remove duplicates
    texts.uniq!

    # transform translations into a hash, sanitizing the keys
    translations = {}
    texts.each{ |text| translations[I18nScrewdriver.for_key(text)] = text }

    # rewrite default language file with updated translations
    puts "Found #{translations.keys.size} unique translations"
    I18nScrewdriver.write_translations(default_locale, translations)

    # process each language we'd like to translate
    (available_locales - [default_locale]).each do |locale|
      filename = I18nScrewdriver.filename(locale)

      # load existing translations
      existing_translations = File.exists?(filename) ? I18nScrewdriver.load_translations(locale) : {}

      # delete removed translations from hash
      existing_translations.reject!{ |k| !translations.has_key?(k) }

      # add new translations
      translations.each_key{ |k| existing_translations[k] ||= "TRANSLATION_MISSING" }

      # write the file
      I18nScrewdriver.write_translations(locale, existing_translations)
    end
  end

  desc 'Translate all not yet translated texts for a given locale'
  task :translate => :environment do
    raise "ERROR: usage: TRANSLATE=de rake i18n:translate" unless ENV['TRANSLATE']
    locale = ENV['TRANSLATE']

    translations = I18nScrewdriver.load_translations(locale)
    puts "Translating #{translations.keys.size} entries to <#{locale}> (enter :q to save and quit):"
    translations.keys.sort.each do |key|
      next unless ["TRANSLATION_MISSING", ""].include?(translations[key])
      puts "> #{key}"
      input = STDIN.gets.chomp
      break if input == ":q"
      translations[key] = input
    end

    puts "Saving translations..."
    I18nScrewdriver.write_translations(locale, translations)
  end
end
