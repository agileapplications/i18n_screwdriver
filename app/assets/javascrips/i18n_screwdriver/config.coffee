I18n.locale = $("html").attr("lang")
I18n.onMissingTranslation ?= (md5, message) ->
  "[#{I18n.locale}] #{message}"
