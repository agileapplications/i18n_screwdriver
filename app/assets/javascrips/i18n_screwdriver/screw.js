//= require i18n_screwdriver/md5

const interpolate = (message, data, links = []) =>
  links.reduce(
    (result, href) => result.replace(/<<(.*?)>>/, `<a href="${href}">$1</a>`),
    message.replace(/%{([^{}]*)}/g, (_, b) => data[b])
  );

I18n.screw = function (message, data, links = []) {
  const md5 = window.md5(message);
  let translation = I18n.translations[I18n.locale][md5];
  if (translation == null) {
    translation = I18n.onMissingTranslation(md5, message);
  }
  return interpolate(translation, data, links);
};
