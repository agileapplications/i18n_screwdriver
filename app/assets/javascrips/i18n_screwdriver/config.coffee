I18n.locale = document.querySelector("html").getAttribute("lang")
I18n.onMissingTranslation ?= (md5, message) ->
  "translation missing: #{I18n.locale}.#{message}"
