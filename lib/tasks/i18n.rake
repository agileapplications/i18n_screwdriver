namespace :i18n do
  desc 'update translation files'
  task :update => :environment do
    I18n::Screwdriver::Scanner.new.run
  end
  
  desc 'translate foreign language file line by line'
  task :translate => :environment do
    language = ENV['TRANSLATE'] || FOREIGN_LANGUAGES.first
    raise "ERROR: usage: TRANSLATE=de rake i18n:translate" unless language
    
    I18n::Screwdriver::Scanner.new.translate(language)
  end
end