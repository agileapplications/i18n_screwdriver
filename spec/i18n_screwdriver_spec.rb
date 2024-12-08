require "spec_helper"

describe I18nScrewdriver do
  describe "grab_js_texts_to_be_translated" do
    it "properly parses the passed string" do
      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screw("test!")|)).to eq(["test!"])
      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screw( "test!")|)).to eq(["test!"])
      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screw("Hi %{name}!", name: "gucki")|)).to eq(["Hi %{name}!"])
      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screw "test!"|)).to eq(["test!"])
      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screw "Hi %{name}!", name: "gucki"|)).to eq(["Hi %{name}!"])

      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screw('test!')|)).to eq(["test!"])
      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screw( 'test!')|)).to eq(["test!"])
      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screw('Hi %{name}!', name: "gucki")|)).to eq(["Hi %{name}!"])
      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screw 'test!'|)).to eq(["test!"])
      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screw 'Hi %{name}!', name: "gucki"|)).to eq(["Hi %{name}!"])

      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screw(`test!`)|)).to eq(["test!"])
      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screw( `test!`)|)).to eq(["test!"])
      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screw(`Hi ${name}!`)"|)).to eq(["Hi ${name}!"])
      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screw(`Hi %{name}!`, name: "gucki")|)).to eq(["Hi %{name}!"])
    end

    it "properly parses the passed string with context" do
      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screw("context\|test!")|)).to eq(["context\|test!"])
    end
  end

  describe "grab_texts_to_be_translated" do
    it "properly parses the passed string" do
      expect(I18nScrewdriver.grab_texts_to_be_translated(%|=_("test!")|)).to eq(["test!"])
      expect(I18nScrewdriver.grab_texts_to_be_translated(%|=_( "test!")|)).to eq(["test!"])
      expect(I18nScrewdriver.grab_texts_to_be_translated(%|=_(\t"test!")|)).to eq(["test!"])
      expect(I18nScrewdriver.grab_texts_to_be_translated(%|=_(\n"test!")|)).to eq(["test!"])
      expect(I18nScrewdriver.grab_texts_to_be_translated(%|=_(  \n   "test!")|)).to eq(["test!"])
      expect(I18nScrewdriver.grab_texts_to_be_translated(%|=_("Hi %{name}!", name: "gucki")|)).to eq(["Hi %{name}!"])

      expect(I18nScrewdriver.grab_texts_to_be_translated(%|=_('test!')|)).to eq(["test!"])
      expect(I18nScrewdriver.grab_texts_to_be_translated(%|=_( 'test!')|)).to eq(["test!"])
      expect(I18nScrewdriver.grab_texts_to_be_translated(%|=_('Hi %{name}!', name: "gucki")|)).to eq(["Hi %{name}!"])
    end
  end

  describe "translates (oh really?)" do
    before do
      I18n.locale = :en
    end
    it "translate a string" do
      expect(I18nScrewdriver.translate("good morning")).to eq("good morning")
      I18n.locale = :it
      expect(I18nScrewdriver.translate("good morning")).to eq("buongiorno")
    end
    it "translate a symbol" do
      expect(I18nScrewdriver.translate(:intro_text)).to eq("a long intro text")
      I18n.locale = :it
      expect(I18nScrewdriver.translate(:intro_text)).to eq("un lungo testo introduttivo")
    end

    it "translate a string with context" do
      expect(I18nScrewdriver.translate("unit|day")).to eq("day")
      I18n.locale = :it
      expect(I18nScrewdriver.translate("unit|day")).to eq("giorno")
    end
  end

  describe "grab_js_texts_to_be_translated with screw based method" do
    it "properly parses the passed string" do
      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screwBasedMethod("test!")|)).to eq(["test!"])
      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screwBasedMethod( "test!")|)).to eq(["test!"])
      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screwBasedMethod("Hi %{name}!", name: "gucki")|)).to eq(["Hi %{name}!"])
      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screwBasedMethod "test!"|)).to eq(["test!"])
      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screwBasedMethod "Hi %{name}!", name: "gucki"|)).to eq(["Hi %{name}!"])
    end

    it "properly parses the passed string" do
      expect(I18nScrewdriver.grab_js_texts_to_be_translated(%|=I18n.screwBasedMethod("context\|test!")|)).to eq(["context|test!"])
    end
  end
end
