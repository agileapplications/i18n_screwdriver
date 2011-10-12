# encoding: utf-8

module I18n
  module Screwdriver
    class Scanner
      
      PATH_TO_LOCALES = "config/locales/"
      LOCALE_PREFIX = "application"
      
      def initialize
        raise "ERROR: FOREIGN_LANGUAGES is not defined" unless defined? FOREIGN_LANGUAGES
        raise "ERROR: DEFAULT_LANGUAGE is not defined" unless defined? DEFAULT_LANGUAGE
        
        @translations = {}
      end
      
      def run
        scan_files
        write_translation_file(@translations, DEFAULT_LANGUAGE)
        
        FOREIGN_LANGUAGES.each do |language|
          update_translations(language)
        end
        
        puts "#{@translations.keys.length} unique translations found"
      end
      
      def translate(language)
        file_name = PATH_TO_LOCALES + LOCALE_PREFIX + ".#{language}.yml"
        raise "File #{file_name} not found!" unless File.exists?(file_name)
        existing_translations = YAML.load_file(file_name)[language]
        
        existing_translations.each do |key, translation|
          if translation.length == 0
            puts "> #{key}"
            input = STDIN.gets.chomp
            if input == ":q"
              break
            else
              existing_translations[key] = input
            end
          end
        end

        write_translation_file(existing_translations, language)
      end
      
      
      private
      
      def update_translations(language)
        existing_translations = {}
        file_name = PATH_TO_LOCALES + LOCALE_PREFIX + ".#{language}.yml"
        existing_translations = YAML.load_file(file_name) if File.exists?(file_name)
        
        syncronize_translations(existing_translations)
        write_translation_file(existing_translations, language)
      end
      
      def syncronize_translations(existing_translations)
        @translations.each_key do |key|
          existing_translations[key] = "" unless existing_translations.has_key?(key)
        end
        existing_translations
      end
      
      def scan_files
        Dir.glob("**/*.{haml,erb,slim,rb}").each do |file_name|
          scan_file(file_name)
        end
      end
      
      def scan_file(file_name)
        File.open(file_name) do |file|
          file.each do |line| 
            @translations.merge!(extract_translation(line))
          end
        end
      end
      
      def extract_translation(line)
        {}.tap do |hash|
          if line =~ /_\("([^"]+)"\)/
            hash[translation_to_key($1)] = $1
          elsif line =~ /_\('([^']+)'\)/
            hash[translation_to_key($1)] = $1
          end
        end
      end
      
      def sorted_translations(translations)
        translations.keys.sort do |a, b|
          a.downcase <=> b.downcase
        end.each do |key|
          yield key, translations[key]
        end
      end
      
      def translation_to_key(translation)
        translation.gsub(/\./, '')
      end
      
      def remove_translation(key)
        @translations.delete(key) #unless translations.has_key?(key)
      end
      
      def write_translation_file(translations, language)
        File.open("config/locales/application.#{language}.yml", "w") do |file|
          file.puts "# use rake task i18n:update to update this file"
          file.puts
          file.puts "\"#{language}\":"
          sorted_translations(translations) do |key, translation|
            file.puts "  \"#{key}\": \"#{translation}\""
          end
        end
      end
    end
  end
end