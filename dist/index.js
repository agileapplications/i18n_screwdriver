var n,e=(n=require("md5"))&&"object"==typeof n&&"default"in n?n.default:n;module.exports=function(n){n.screw=function(r,t,o){var i;void 0===o&&(o=[]);var u=e(r),a=null===(i=n.translations[n.locale])||void 0===i?void 0:i[u];return void 0===a&&(a=function(n,e,r){return"translation missing: "+n.locale+"."+r}(n,0,r)),function(n,e,r){return void 0===r&&(r=[]),r.reduce(function(n,e){return n.replace(/<<(.*?)>>/,'<a href="'+e+'">$1</a>')},n.replace(/%{([^{}]*)}/g,function(n,r){return e[r]}))}(a,t,o)}};
//# sourceMappingURL=index.js.map
