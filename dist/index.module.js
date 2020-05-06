import n from"md5";export default function(r){r.screw=function(t,o){var i,e=n(t),u=null===(i=r.translations[r.locale])||void 0===i?void 0:i[e];return void 0===u&&(u=function(n,r,t){return"translation missing: "+n.locale+"."+t}(r,0,t)),function(n,r){return n.replace(/%{([^{}]*)}/g,function(n,t){return r[t]})}(u,o)}}
//# sourceMappingURL=index.module.js.map
