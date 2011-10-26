module I18nScrewdriver
  module Translation
    def _(text, options = {})
      I18n.translate(I18nScrewdriver.for_key(text), options)
    end
  end
end

Object.send(:include, I18nScrewdriver::Translation)

