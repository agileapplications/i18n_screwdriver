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
    end
  end
end
