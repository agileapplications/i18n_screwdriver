require 'helper'

class TestI18nScrewdriver < Test::Unit::TestCase  
  should "remove dots from translation string" do
    assert "mynewtranslation", _("my.new.translation")
  end
end
