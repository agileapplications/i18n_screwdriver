require 'helper'

class TestI18nScrewdriver < Test::Unit::TestCase  
  should "remove dots from translation string" do
    assert_equal "<span class=\"translation_missing\">en, mynewtranslation</span>", _("my.new.translation")
  end
end
