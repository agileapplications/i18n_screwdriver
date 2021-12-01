import md5 from "md5";

function onMissingTranslation(I18n, md5, message) {
  return `translation missing: ${I18n.locale}.${message}`;
}

const interpolate = (message, data, links = []) =>
  links.reduce(
    (result, href) => result.replace(/<<(.*?)>>/, `<a href="${href}">$1</a>`),
    message.replace(/%{([^{}]*)}/g, (_, b) => data[b])
  );

export default function configure(I18n) {
  I18n.screw = function screw(message, data, links = []) {
    const hash = md5(message);
    let translation = I18n.translations[I18n.locale]?.[hash];
    if (typeof translation === "undefined") {
      translation = onMissingTranslation(I18n, hash, message);
    }
    return interpolate(translation, data, links);
  };
}
