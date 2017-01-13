#= require i18n_screwdriver/md5

interpolate = (message, data) ->
  message.replace(/%{([^{}]*)}/g, (a, b) -> data[b])

I18n.screw = (message, data) ->
  md5 = window.md5(message)
  translation = I18n.translations[I18n.locale][md5]
  translation ?= "[#{I18n.locale}] #{message}"
  interpolate(translation, data)
