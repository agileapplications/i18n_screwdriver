require "i18n_screwdriver/version"
require "i18n_screwdriver/translation"
require "i18n_screwdriver/translation_helper"
require "i18n_screwdriver/rails"

module I18nScrewdriver
  def self.filename(locale)
    "config/locales/application.#{locale}.yml"
  end

  def self.for_key(string)
    Digest::MD5.hexdigest(string.strip)
  end

  def self.load_translations(locale)
    filename = self.filename(locale)
    raise "File #{filename} not found!" unless File.exists?(filename)
    YAML.load_file(filename)[locale]
  end

  def self.write_translations(locale, translations)
    File.open(filename(locale), "w") do |file|
      file.puts "# use rake task i18n:update to generate this file"
      file.puts
      file.puts({locale => in_utf8(translations)}.to_yaml)
      file.puts
    end
  end

  def self.grab_texts_to_be_translated(string)
    [].tap do |texts|
      texts.concat(string.scan(/_\("(.*?)"\)/).map{ |v| unescape_string(v[0]) })
      texts.concat(string.scan(/_\('(.*?)'\)/).map{ |v| unescape_string(v[0]) })
    end
  end

  def self.in_utf8(hash)
    {}.tap do |result|
      hash.each do |k, v|
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
end

