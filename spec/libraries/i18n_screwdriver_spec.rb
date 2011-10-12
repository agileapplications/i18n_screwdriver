require 'spec_helper'

describe I18n::Screwdriver do

  describe "translation helper" do
    it "removes dots from translation string" do
      _("my.new.translation").should == "translation missing: en.mynewtranslation"
    end
  end
  
end