require "i18n_screwdriver/version"
require "i18n_screwdriver/translation"
require "i18n_screwdriver/translation_helper"
require "i18n_screwdriver/rails"

module I18nScrewdriver
  def self.filename_for_locale(locale)
    File.join("config", "locales", "application.#{locale}.yml")
  end

  def self.for_key(string)
    string = string.strip
    (string =~ /^:[a-z][a-z0-9_]*$/) ? string : Digest::MD5.hexdigest(string)
  end

  def self.file_with_translations_exists?(locale)
    File.exists?(filename_for_locale(locale))
  end

  def self.load_translations(locale)
    path = filename_for_locale(locale)
    raise "File #{path} not found!" unless File.exists?(path)
    sanitize_hash(YAML.load_file(path)[locale])
  end

  def self.write_translations(locale, translations)
    File.open(filename_for_locale(locale), "w") do |file|
      file.puts "# use rake task i18n:update to generate this file"
      file.puts
      file.puts({locale => in_utf8(translations)}.to_yaml)
      file.puts
    end
  end

  def self.grab_texts_to_be_translated(string)
    [].tap do |texts|
      texts.concat(string.scan(/_\((?<!\\)"(.*?)(?<!\\)"\)/).map{ |v| unescape_string(v[0]) })
      texts.concat(string.scan(/_\((?<!\\)'(.*?)(?<!\\)'\)/).map{ |v| unescape_string(v[0]) })
    end
  end

  def self.grab_symbols_to_be_translated(string)
    string.scan(/_\((:[a-z][a-z0-9_]*)\)/).flatten
  end

  def self.in_utf8(hash)
    {}.tap do |result|
      hash.sort.each do |k, v|
        result[k.encode('UTF-8')] = (v || "").encode('UTF-8')
      end
    end
  end

  def self.unescape_string(string)
    "".tap do |result|
      in_backslash = false
      string.each_char do |char|
        if in_backslash
          case char
          when 'r'
            result << "\r"
          when 'n'
            result << "\n"
          when 't'
            result << "\t"
          when '"', "'", '\\'
            result << char
          else
            result << '\\'
            result << char
          end
          in_backslash = false
        else
          case char
          when '\\'
            in_backslash = true
          else
            result << char
          end
        end
      end
    end
  end

  def self.gather_translations
    texts = []
    symbols = []
    Dir.glob("**/*.{haml,erb,slim,rb}").each do |file|
      input = File.read(file)
      texts.concat(grab_texts_to_be_translated(input))
      symbols.concat(grab_symbols_to_be_translated(input))
    end
    translations = Hash[texts.uniq.map{ |text| [for_key(text), text] }]
    translations.merge(Hash[symbols.uniq.map{ |symbol| [for_key(symbol), ""] }])
  end

  def self.default_locale
    @default_locale ||= begin
      raise "Please set I18.default_locale" unless I18n.default_locale.present?
      I18n.default_locale.to_s
    end
  end

  def self.available_locales
    @available_locales ||= begin
      raise "Please set I18.available_locales" unless I18n.available_locales.count > 0
      I18n.available_locales.map(&:to_s)
    end
  end

  def self.dummy_text
    "TRANSLATION_MISSING"
  end

  def self.update_translations_file(locale, translations)
    existing_translations = file_with_translations_exists?(locale) ? load_translations(locale) : {}
    existing_translations.select!{ |k| translations.has_key?(k) }

    translations.each do |k, v|
      next if existing_translations[k]
      existing_translations[k] = (default_locale == locale) ? v : dummy_text
    end

    write_translations(locale, existing_translations)
  end

  def self.sanitize_hash(hash)
    {}.tap do |new_hash|
      hash.each{ |k, v| new_hash[k.to_s] = v.to_s }
    end
  end
end
