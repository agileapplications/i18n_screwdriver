import n from"md5";export default function(r){r.screw=function(o,t,e){var i;void 0===e&&(e=[]);var u=n(o),a=null===(i=r.translations[r.locale])||void 0===i?void 0:i[u];return void 0===a&&(a=function(n,r,o){return"translation missing: "+n.locale+"."+o}(r,0,o)),function(n,r,o){return void 0===o&&(o=[]),o.reduce(function(n,r){return n.replace(/<<(.*?)>>/,'<a href="'+r+'">$1</a>')},n.replace(/%{([^{}]*)}/g,function(n,o){return r[o]}))}(a,t,e)}}
//# sourceMappingURL=index.modern.js.map
