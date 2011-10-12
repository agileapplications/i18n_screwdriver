require 'spec_helper'

describe I18n::Screwdriver::Scanner do
  
  before do
    @scanner = I18n::Screwdriver::Scanner.new
  end

  describe "extract_translation" do
    it "returns an empty hash when no translation was found" do
      @scanner.send(:extract_translation, 'hello world').should == {}
    end
    
    it "returns a filled hash when translation was found" do
      @scanner.send(:extract_translation, '_("hello world")').should == {
        'hello world' => 'hello world'
      }
      
      @scanner.send(:extract_translation, '_("Going out today.")').should == {
        'Going out today' => 'Going out today.'
      }
      
      @scanner.send(:extract_translation, '_(".a.b.c.d.e")').should == {
        'abcde' => '.a.b.c.d.e'
      }
    end
  end
  
  describe "translation_to_key" do
    it "removes all dots" do
      @scanner.send(:translation_to_key, 'Good morning.').should == 'Good morning'
    end
  end
  
  describe "sorted_translations" do
    it "returns all translations sorted" do
      #@scanner.send(:sorted_translations) do |key, translation|
      #  puts "  \"#{key}\": \"#{translation}\""
      #end
    end
  end
  
end