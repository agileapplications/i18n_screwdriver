I18n.locale = document.querySelector("html").getAttribute("lang");
if (I18n.onMissingTranslation == null) {
  I18n.onMissingTranslation = (md5, message) =>
    `translation missing: ${I18n.locale}.${message}`;
}
