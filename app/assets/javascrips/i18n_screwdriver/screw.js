//= require i18n_screwdriver/md5

const interpolate = (message, data, links, render) => {
  const interpolated = message.replace(/%{([^{}]*)}/g, (_, b) => data[b]);

  if (typeof render === "function") {
    const parts = interpolated.match(/<<.*?>>|.+?(?=<<.*?>>|$)/g) || [];

    let linkIndex = 0;

    return parts.map((part, index) => {
      if (part.startsWith("<<") && part.endsWith(">>")) {
        const href = links[linkIndex];
        if (typeof href === "undefined") {
          throw new Error("More links in template string than hrefs");
        }

        linkIndex++;
        return render({ text: part.slice(2, -2), href, index });
      }

      return render({ text: part, index });
    });
  }

  return links.reduce(
    (result, href) => result.replace(/<<(.*?)>>/, `<a href="${href}">$1</a>`),
    interpolated
  );
};

I18n.screw = function screw(message, data, { links = [], render } = {}) {
  const hash = md5(message);
  let translation = I18n.translations[I18n.locale]?.[hash];
  if (typeof translation === "undefined") {
    translation = onMissingTranslation(I18n, hash, message);
  }
  return interpolate(translation, data, links, render);
};
