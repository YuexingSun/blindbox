(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["pages-service-service"],{"76be":function(n,t,r){"use strict";r.d(t,"b",(function(){return c})),r.d(t,"c",(function(){return a})),r.d(t,"a",(function(){return e}));var e={htmlView:r("48fd").default},c=function(){var n=this,t=n.$createElement,r=n._self._c||t;return r("v-uni-view",{staticStyle:{padding:"8px","box-sizing":"border-box"}},[r("htmlView",{attrs:{html:n.html}})],1)},a=[]},a18c:function(n,t,r){"use strict";r.r(t);var e=r("76be"),c=r("b533");for(var a in c)"default"!==a&&function(n){r.d(t,n,(function(){return c[n]}))}(a);r("e4ce");var i,o=r("f0c5"),u=Object(o["a"])(c["default"],e["b"],e["c"],!1,null,"1bdb50ec",null,!1,e["a"],i);t["default"]=u.exports},b533:function(n,t,r){"use strict";r.r(t);var e=r("c05d"),c=r.n(e);for(var a in e)"default"!==a&&function(n){r.d(t,n,(function(){return e[n]}))}(a);t["default"]=c.a},b635:function(n,t,r){var e=r("c8ce");"string"===typeof e&&(e=[[n.i,e,""]]),e.locals&&(n.exports=e.locals);var c=r("4f06").default;c("79ab4ea4",e,!0,{sourceMap:!1,shadowMode:!1})},c05d:function(n,t,r){"use strict";(function(n){var e=r("4ea4");Object.defineProperty(t,"__esModule",{value:!0}),t.default=void 0;var c=e(r("48fd")),a={components:{htmlView:c.default},data:function(){return{html:""}},methods:{getcontant:function(){var t=this;this.$api.global.service().then((function(r){n.log(r),t.html=r.content})).catch((function(t){n.log(t)}))}},onShow:function(){this.getcontant()}};t.default=a}).call(this,r("5a52")["default"])},c8ce:function(n,t,r){var e=r("24fb");t=e(!1),t.push([n.i,'@charset "UTF-8";\r\n/**\r\n * 这里是uni-app内置的常用样式变量\r\n *\r\n * uni-app 官方扩展插件及插件市场（https://ext.dcloud.net.cn）上很多三方插件均使用了这些样式变量\r\n * 如果你是插件开发者，建议你使用scss预处理，并在插件代码中直接使用这些变量（无需 import 这个文件），方便用户通过搭积木的方式开发整体风格一致的App\r\n *\r\n */\r\n/**\r\n * 如果你是App开发者（插件使用者），你可以通过修改这些变量来定制自己的插件主题，实现自定义主题功能\r\n *\r\n * 如果你的项目同样使用了scss预处理，你也可以直接在你的 scss 代码中使用如下变量，同时无需 import 这个文件\r\n */\r\n/* 颜色变量 */\r\n/* 行为相关颜色 */\r\n/* 文字基本颜色 */\r\n/* 背景颜色 */\r\n/* 边框颜色 */\r\n/* 尺寸变量 */\r\n/* 文字尺寸 */\r\n/* 图片尺寸 */\r\n/* Border Radius */\r\n/* 水平间距 */\r\n/* 垂直间距 */\r\n/* 透明度 */\r\n/* 文章场景相关 */p[data-v-1bdb50ec]{margin:%?32?% 0}ol[data-v-1bdb50ec]{margin:%?32?% 0}',""]),n.exports=t},e4ce:function(n,t,r){"use strict";var e=r("b635"),c=r.n(e);c.a}}]);