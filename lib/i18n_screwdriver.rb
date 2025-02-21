require "i18n_screwdriver/version"
require "i18n_screwdriver/translation"
require "i18n_screwdriver/translation_helper"
require "i18n_screwdriver/rails"

module I18nScrewdriver
  Error = Class.new(StandardError)

  class << self
    attr_accessor :excluded_paths, :included_gems
  end

  self.excluded_paths = [%r{/tmp/}, %r{/node_modules/}, %r{/packs/}, %r{/packs-test}]
  self.included_gems = []

  def self.filename_for_locale(locale)
    File.join("config", "locales", "application.#{locale}.yml")
  end

  def self.generate_key(source)
    return ":#{source}" if source.is_a?(Symbol)
    source = source.strip
    (source =~ /^:[a-z][a-z0-9_]*$/) ? source : Digest::MD5.hexdigest(source)
  end

  def self.file_with_translations_exists?(locale)
    File.exist?(filename_for_locale(locale))
  end

  def self.load_translations(locale)
    path = filename_for_locale(locale)
    raise Error, "File #{path} not found!" unless File.exist?(path)
    sanitize_hash(YAML.load_file(path)[locale])
  end

  def self.write_translations(locale, translations)
    File.open(filename_for_locale(locale), "w") do |file|
      file.puts "# use rake task i18n:update to generate this file"
      file.puts
      file.puts({locale => in_utf8(translations)}.to_yaml(:line_width => -1))
      file.puts
    end
  end

  def self.grab_texts_to_be_translated(string)
    [].tap do |texts|
      texts.concat(string.scan(/_\((?<!\\)"(.*?)(?<!\\)"/).map{ |v| unescape_string(v[0]) })
      texts.concat(string.scan(/_\((?<!\\)'(.*?)(?<!\\)'/).map{ |v| unescape_string(v[0]) })
    end
  end

  def self.grab_symbols_to_be_translated(string)
    string.scan(/_\((:[a-z][a-z0-9_]*)\)/).flatten
  end

  def self.grab_js_texts_to_be_translated(string)
    [].tap do |texts|
      texts.concat(string.scan(/\bI18n\.screw\w*\(?\s*(?<!\\)"(.*?)(?<!\\)"/).map{ |v| unescape_string(v[0]) })
      texts.concat(string.scan(/\bI18n\.screw\w*\(?\s*(?<!\\)'(.*?)(?<!\\)'/).map{ |v| unescape_string(v[0]) })
      texts.concat(string.scan(/\bI18n\.screw\w*\(?\s*(?<!\\)`(.*?)(?<!\\)`/).map{ |v| unescape_string(v[0]) })
    end
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

  def self.excluded_path?(path)
    excluded_paths.detect{ |excluded_path| path =~ excluded_path }
  end

  def self.gather_ruby_translations(path, texts, symbols)
    Dir.glob("#{path}/**/*.{haml,erb,slim,rb}").each do |file|
      next unless File.file?(file)
      next if excluded_path?(file)
      puts "Scanning #{file}..."
      input = File.read(file)
      texts.concat(grab_texts_to_be_translated(input))
      symbols.concat(grab_symbols_to_be_translated(input))
    end
  end

  def self.gather_js_translations(path, texts)
    Dir.glob("#{path}/**/*.{js,jsx,ts,tsx,coffee,hamlc,ejs,erb}").each do |file|
      next unless File.file?(file)
      next if excluded_path?(file)
      puts "Scanning #{file}..."
      input = File.read(file)
      texts.concat(grab_js_texts_to_be_translated(input))
    end
  end

  def self.gather_translations
    texts = []
    symbols = []

    gather_ruby_translations(".", texts, symbols)
    gather_js_translations(".", texts)

    included_gems.each do |name|
      spec = Gem.loaded_specs[name]
      next puts "WARNING: gem #{name} not loaded, so it cannot be scanned for translations!" unless spec
      gather_ruby_translations(spec.full_gem_path, texts, symbols)
      gather_js_translations(spec.full_gem_path, texts)
    end

    translations = Hash[texts.uniq.map{ |text| [generate_key(text), text] }]
    translations.merge(Hash[symbols.uniq.map{ |symbol| [generate_key(symbol), ""] }])
  end

  def self.default_locale
    @default_locale ||= begin
      raise Error, "Please set I18.default_locale" unless I18n.default_locale.present?
      I18n.default_locale.to_s
    end
  end

  def self.available_locales
    @available_locales ||= begin
      raise Error, "Please set I18.available_locales" unless I18n.available_locales.count > 0
      I18n.available_locales.map(&:to_s)
    end
  end

  def self.update_translations_file(locale, translations)
    existing_translations = file_with_translations_exists?(locale) ? load_translations(locale) : {}
    existing_translations.select!{ |k| translations.has_key?(k) }

    translations.each do |k, v|
      next if existing_translations[k]
      existing_translations[k] = (default_locale == locale) ? v : nil
    end

    write_translations(locale, existing_translations)
  end

  def self.sanitize_hash(hash)
    {}.tap do |new_hash|
      hash.each{ |k, v| new_hash[k.to_s] = v.to_s }
    end
  end

  def self.translate(string, **options)
    escaped_options = options.transform_values do |value|
      next value unless value.is_a?(String)

      value.gsub("|", "<PIPE/>")
    end

    I18n.translate!(generate_key(string), **escaped_options).split("|").last.gsub("<PIPE/>", "|")
  rescue I18n::MissingTranslationData
    I18n.translate(string, **options)
  end
end
