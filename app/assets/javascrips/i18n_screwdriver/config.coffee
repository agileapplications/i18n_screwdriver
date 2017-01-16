I18n.locale = $("html").attr("lang")
I18n.onMissingTranslation ?= (md5, message) ->
  "translation missing: #{I18n.locale}.#{message}"
