module I18nScrewdriver
  module TranslationHelper
    def _(text, options = {}, &block)
      Translation.new(text, options, &block)
    end
  end
end

Object.send(:include, I18nScrewdriver::TranslationHelper)

