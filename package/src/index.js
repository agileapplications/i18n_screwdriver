import md5 from "md5";
import I18n from "i18n-js";

function onMissingTranslation(md5, message) {
  return `translation missing: ${I18n.locale}.${message}`;
}

const interpolate = (message, data) =>
  message.replace(/%{([^{}]*)}/g, (a, b) => data[b]);

export default function configure(I18n) {
  I18n.screw = function screw(message, data) {
    const hash = md5(message);
    let translation = I18n.translations[I18n.locale]?.[hash];
    if (typeof translation === "undefined") {
      translation = onMissingTranslation(hash, message);
    }
    return interpolate(translation, data);
  };
}
