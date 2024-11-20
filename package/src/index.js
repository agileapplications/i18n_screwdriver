import md5 from "md5";

function onMissingTranslation(I18n, md5, message) {
  return `translation missing: ${I18n.locale}.${message}`;
}

const interpolate = (message, data) =>
  message.replace(/%{([^{}]*)}/g, (a, b) => data[b]);

export default function configure(I18n) {
  I18n.screw = function screw(message, data) {
    const hash = md5(message);
    let translation = I18n.translations[I18n.locale]?.[hash];
    if (typeof translation === "undefined") {
      translation = onMissingTranslation(I18n, hash, message);
    }

    const [context, phrase] = translation.split("|");
    return interpolate(phrase ?? context ?? "", data);
  };
}
