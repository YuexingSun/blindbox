webpackJsonp([12],{"7FFz":function(n,o,t){n.exports=t.p+"static/img/coupon_old.a435146.png"},AwQ0:function(n,o,t){"use strict";function e(n){t("eNup"),t("TYIo")}Object.defineProperty(o,"__esModule",{value:!0});var i=t("vMJZ"),a=t("odqc"),s=t("Znkm"),c=t("8pLc"),p=(a.a,s.a,c.a,{name:"loginRegister",components:{Tab:a.a,TabItem:s.a,noData:c.a},data:function(){return{stroke:"static/images/stroke.png",strokestaus:0,isShow:!1,showlist:!1,canusenum:"",notusenum:"",curid:"",canuselist:[],notuselist:[],listData:{img:"static/images/stroke.png",text:"您还没领到优惠券哦~"}}},methods:{chiose:function(){0===this.strokestaus?(this.stroke="static/images/strokeCur.png",this.strokestaus=1):(this.stroke="static/images/stroke.png",this.strokestaus=0)},showitem:function(n){this.showlist=!this.showlist},couponRuleMain:function(){this.isShow=!this.isShow},myTicketist:function(){var n=this,o={},t=this;Object(i.t)(o).then(function(o){0===o.data.errorcode?(t.canuselist=o.data.data.canuselist,t.notuselist=o.data.data.notuselist,console.log(o.data.data.canuselist.length),0===o.data.data.canuselist.length?n.canusenum="无":n.canusenum=o.data.data.canuselist.length,0===o.data.data.notuselist.length?n.notusenum="无":n.notusenum=o.data.data.notuselist.length):n.$vux.toast.text(o.data.errormsg,"middle")}).catch(function(o){n.$vux.toast.text("网络异常！","middle")})}},created:function(){this.myTicketist()}}),r=function(){var n=this,o=n.$createElement,e=n._self._c||o;return e("div",{attrs:{id:"usercoupon"}},[e("tab",{attrs:{"line-width":2,"custom-bar-width":"56px","active-color":"#008fe2"}},[e("tab-item",{attrs:{selected:""},on:{"on-item-click":n.showitem}},[n._v("可用("+n._s(n.canusenum)+")")]),n._v(" "),e("tab-item",{on:{"on-item-click":n.showitem}},[n._v("不可用("+n._s(n.notusenum)+")")])],1),n._v(" "),e("div",{directives:[{name:"show",rawName:"v-show",value:!n.showlist,expression:"!showlist"}],staticClass:"couponDo"},[n._l(n.canuselist,function(o,t){return e("div",{key:t,staticClass:"main couponListmain"},[e("div",{staticClass:"couponList"},[e("div",{staticClass:"couponmain"},[e("div",{staticClass:"coupontop",on:{click:function(o){n.chiose()}}},[e("div",{directives:[{name:"show",rawName:"v-show",value:1==o.type,expression:"canuse.type==1"}],staticClass:"couponPrice"},[e("span",{staticStyle:{"font-size":"16px"}},[n._v("￥")]),n._v(n._s(parseInt(o.ticketmoney)))]),n._v(" "),e("div",{directives:[{name:"show",rawName:"v-show",value:2==o.type,expression:"canuse.type==2"}],staticClass:"couponPrice"},[n._v(n._s(parseFloat(o.ticketmoney))),e("span",{staticStyle:{"font-size":"14px"}},[n._v("折")])]),n._v(" "),e("div",{staticClass:"couponTerm"},[e("p",{staticClass:"couponTermClass"},[n._v(n._s(o.title))]),e("p",{staticClass:"couponTermClass"},[n._v("满"+n._s(parseInt(o.uptomoney))+"元可用")])]),n._v(" "),e("router-link",{attrs:{to:"/classifyticket?ticketid="+o.ticketid}},[e("div",{staticClass:"coupongo"},[n._v("去使用")])])],1),n._v(" "),e("div",{staticClass:"couponTime"},[e("p",[n._v("有效期："+n._s(o.usestart)+"-"+n._s(o.useend))]),n._v(" "),""!==o.txt?e("div",{staticClass:"couponRule",class:{current:n.curid===o.ticketid},on:{click:function(t){n.curid===o.ticketid?n.curid="":n.curid=o.ticketid}}},[n._v("使用规则")]):n._e()])])]),n._v(" "),e("div",{directives:[{name:"show",rawName:"v-show",value:n.curid===o.ticketid,expression:"curid===canuse.ticketid"}],staticClass:"couponRuleMain"},[e("p",[n._v(n._s(o.txt))])])])}),n._v(" "),e("no-data",{directives:[{name:"show",rawName:"v-show",value:"无"===n.canusenum,expression:'canusenum==="无"'}],attrs:{tipsTxt:"您还没有优惠券哦~",tipsImg:"static/images/coupon_empty.png"}})],2),n._v(" "),e("div",{directives:[{name:"show",rawName:"v-show",value:n.showlist,expression:"showlist"}],staticClass:"couponDo couponExpire"},[n._l(n.notuselist,function(o,i){return e("div",{key:i,staticClass:"main couponListmain"},[e("div",{staticClass:"couponList"},[e("div",{staticClass:"couponmain"},[e("div",{staticClass:"coupontop",on:{click:function(o){n.chiose()}}},[e("div",{directives:[{name:"show",rawName:"v-show",value:1==o.type,expression:"notuse.type==1"}],staticClass:"couponPrice"},[e("span",{staticStyle:{"font-size":"16px"}},[n._v("￥")]),n._v(n._s(parseInt(o.ticketmoney)))]),n._v(" "),e("div",{directives:[{name:"show",rawName:"v-show",value:2==o.type,expression:"notuse.type==2"}],staticClass:"couponPrice"},[n._v(n._s(parseFloat(o.ticketmoney))),e("span",{staticStyle:{"font-size":"14px"}},[n._v("折")])]),n._v(" "),e("div",{staticClass:"couponTerm"},[e("p",{staticClass:"couponTermClass"},[n._v(n._s(o.title))]),e("p",{staticClass:"couponTermClass"},[n._v("满"+n._s(parseInt(o.uptomoney))+"元可用")])]),n._v(" "),"overtime"==o.reson?e("img",{staticClass:"stroke",attrs:{src:t("7FFz")}}):"used"==o.reson?e("img",{staticClass:"stroke",attrs:{src:t("aN5K")}}):n._e()]),n._v(" "),e("div",{staticClass:"couponTime"},[e("p",[n._v("有效期："+n._s(o.usestart)+"-"+n._s(o.useend))]),n._v(" "),""!==o.txt?e("div",{staticClass:"couponRule",class:{current:n.curid===o.ticketid},on:{click:function(t){n.curid===o.ticketid?n.curid="":n.curid=o.ticketid}}},[n._v("使用规则")]):n._e()])])]),n._v(" "),e("div",{directives:[{name:"show",rawName:"v-show",value:n.curid===o.ticketid,expression:"curid===notuse.ticketid"}],staticClass:"couponRuleMain"},[e("p",[n._v(n._s(o.txt))])])])}),n._v(" "),e("no-data",{directives:[{name:"show",rawName:"v-show",value:"无"===n.notusenum,expression:'notusenum==="无"'}],attrs:{tipsTxt:"您还没有优惠券哦~",tipsImg:"static/images/coupon_empty.png"}})],2)],1)},u=[],d={render:r,staticRenderFns:u},A=d,m=t("VU/8"),l=e,C=m(p,A,!1,l,"data-v-07dea7cd",null);o.default=C.exports},TYIo:function(n,o,t){var e=t("mAky");"string"==typeof e&&(e=[[n.i,e,""]]),e.locals&&(n.exports=e.locals);t("rjj0")("53a1b12d",e,!0,{})},aN5K:function(n,o,t){n.exports=t.p+"static/img/coupon_use.7bfc636.png"},eNup:function(n,o,t){var e=t("wR+y");"string"==typeof e&&(e=[[n.i,e,""]]),e.locals&&(n.exports=e.locals);t("rjj0")("04abbfed",e,!0,{})},mAky:function(n,o,t){o=n.exports=t("FZ+f")(!0),o.push([n.i,"\n#usercoupon .vux-tab div::before {\n  display: none;\n}\n","",{version:3,sources:["/Users/binyang/work/edifier/jing_code/waptest/src/views/user/coupon.vue"],names:[],mappings:";AACA;EACE,cAAc;CACf",file:"coupon.vue",sourcesContent:["\n#usercoupon .vux-tab div::before {\n  display: none;\n}\n"],sourceRoot:""}])},"wR+y":function(n,o,t){o=n.exports=t("FZ+f")(!0),o.push([n.i,"\n.main[data-v-07dea7cd] {\n  width: 9.2rem;\n  margin: 0 auto;\n}\n.empty img[data-v-07dea7cd] {\n  width: 2.666667rem;\n  display: block;\n  margin: 4rem auto .266667rem auto;\n}\n.empty p[data-v-07dea7cd] {\n  text-align: center;\n  color: #999;\n  font-size: 0.4rem;\n}\n.couponDo .couponListmain[data-v-07dea7cd] {\n  background: #afbed4;\n  border-radius: .08rem;\n}\n.couponDo .couponListmain .couponList[data-v-07dea7cd] {\n  margin-top: .266667rem;\n  border-radius: .08rem;\n  padding: .4rem;\n  position: relative;\n}\n.couponDo .couponListmain .couponList .coupontop[data-v-07dea7cd] {\n  display: -webkit-box;\n  display: -webkit-flex;\n  display: flex;\n  -webkit-box-align: center;\n  -webkit-align-items: center;\n          align-items: center;\n  position: relative;\n}\n.couponDo .couponListmain .couponList .coupontop .couponPrice[data-v-07dea7cd] {\n  width: 3rem;\n  color: #fff;\n  height: 1.333333rem;\n  line-height: 1.333333rem;\n  font-size: .68rem;\n  text-align: left;\n}\n.couponDo .couponListmain .couponList .coupontop .stroke[data-v-07dea7cd] {\n  position: absolute;\n  width: .533333rem;\n  height: .533333rem;\n  top: 0;\n  right: 0;\n}\n.couponDo .couponListmain .couponList .coupontop .couponTerm[data-v-07dea7cd] {\n  margin-left: -0.733333rem;\n  width: 3.8rem;\n}\n.couponDo .couponListmain .couponList .coupontop .couponTerm p[data-v-07dea7cd] {\n  white-space: wrap;\n}\n.couponDo .couponListmain .couponList .coupontop .couponTerm .couponTermPrice[data-v-07dea7cd] {\n  color: #fff;\n  font-size: 0.48rem;\n}\n.couponDo .couponListmain .couponList .coupontop .couponTerm .couponTermClass[data-v-07dea7cd] {\n  color: #fff;\n  font-size: 0.373333rem;\n}\n.couponDo .couponListmain .couponList .coupontop .coupongo[data-v-07dea7cd] {\n  width: 2.133333rem;\n  height: .8rem;\n  line-height: .8rem;\n  text-align: center;\n  background: #fff;\n  border-radius: .08rem;\n  color: #6d89b0;\n  font-size: .373333rem;\n  position: absolute;\n  top: 0.25rem;\n  right: 0;\n}\n.couponDo .couponListmain .couponList .couponTime[data-v-07dea7cd] {\n  display: -webkit-box;\n  display: -webkit-flex;\n  display: flex;\n  -webkit-box-pack: justify;\n  -webkit-justify-content: space-between;\n          justify-content: space-between;\n  margin-top: .266667rem;\n  color: #fff;\n  font-size: 0.346667rem;\n}\n.couponDo .couponListmain .couponList .couponTime .couponRule[data-v-07dea7cd] {\n  position: relative;\n  display: -webkit-box;\n  display: -webkit-flex;\n  display: flex;\n  -webkit-box-align: center;\n  -webkit-align-items: center;\n          align-items: center;\n}\n.couponDo .couponListmain .couponList .couponTime .couponRule[data-v-07dea7cd]::after {\n  content: '';\n  width: 8px;\n  height: 8px;\n  border-top: 2px solid #fff;\n  border-right: 2px solid #fff;\n  -webkit-transform: rotate(135deg);\n          transform: rotate(135deg);\n  display: inline-block;\n  margin: 0 0 5px 8px;\n}\n.couponDo .couponListmain .couponList .couponTime .couponRule.current[data-v-07dea7cd]::after {\n  -webkit-transform: rotate(-45deg);\n          transform: rotate(-45deg);\n  margin: 5px 0 0 8px;\n}\n.couponDo .couponRuleMain[data-v-07dea7cd] {\n  border-top: 1px dashed #e3e3e3;\n  padding: .2rem .4rem;\n  color: #6d89b0;\n  font-size: 0.346667rem;\n}\n.couponDo.couponExpire .couponListmain[data-v-07dea7cd] {\n  background: #fff;\n}\n.couponDo.couponExpire .couponListmain .couponTermPrice[data-v-07dea7cd],\n.couponDo.couponExpire .couponListmain .couponTermClass[data-v-07dea7cd],\n.couponDo.couponExpire .couponListmain .couponPrice[data-v-07dea7cd] {\n  color: #666 !important;\n}\n.couponDo.couponExpire .couponListmain .stroke[data-v-07dea7cd] {\n  width: 1.333333rem !important;\n  height: 1.333333rem !important;\n}\n.couponDo.couponExpire .couponListmain .couponTime[data-v-07dea7cd] {\n  color: #999 !important;\n}\n.couponDo.couponExpire .couponListmain .couponTime .couponRule[data-v-07dea7cd]::after {\n  content: '';\n  width: 8px;\n  height: 8px;\n  border-top: 2px solid #999;\n  border-right: 2px solid #999;\n  -webkit-transform: rotate(135deg);\n          transform: rotate(135deg);\n  display: inline-block;\n  margin: 0 0 5px 8px;\n}\n.couponDo.couponExpire .couponListmain .couponTime .couponRule.current[data-v-07dea7cd]::after {\n  -webkit-transform: rotate(-45deg);\n          transform: rotate(-45deg);\n  margin: 5px 0 0 8px;\n}\n.couponDo.couponExpire .couponRuleMain[data-v-07dea7cd] {\n  color: #999 !important;\n}\n","",{version:3,sources:["/Users/binyang/work/edifier/jing_code/waptest/src/views/user/coupon.vue"],names:[],mappings:";AACA;EACE,cAAc;EACd,eAAe;CAChB;AACD;EACE,mBAAmB;EACnB,eAAe;EACf,kCAAkC;CACnC;AACD;EACE,mBAAmB;EACnB,YAAY;EACZ,kBAAkB;CACnB;AACD;EACE,oBAAoB;EACpB,sBAAsB;CACvB;AACD;EACE,uBAAuB;EACvB,sBAAsB;EACtB,eAAe;EACf,mBAAmB;CACpB;AACD;EACE,qBAAqB;EACrB,sBAAsB;EACtB,cAAc;EACd,0BAA0B;EAC1B,4BAA4B;UACpB,oBAAoB;EAC5B,mBAAmB;CACpB;AACD;EACE,YAAY;EACZ,YAAY;EACZ,oBAAoB;EACpB,yBAAyB;EACzB,kBAAkB;EAClB,iBAAiB;CAClB;AACD;EACE,mBAAmB;EACnB,kBAAkB;EAClB,mBAAmB;EACnB,OAAO;EACP,SAAS;CACV;AACD;EACE,0BAA0B;EAC1B,cAAc;CACf;AACD;EACE,kBAAkB;CACnB;AACD;EACE,YAAY;EACZ,mBAAmB;CACpB;AACD;EACE,YAAY;EACZ,uBAAuB;CACxB;AACD;EACE,mBAAmB;EACnB,cAAc;EACd,mBAAmB;EACnB,mBAAmB;EACnB,iBAAiB;EACjB,sBAAsB;EACtB,eAAe;EACf,sBAAsB;EACtB,mBAAmB;EACnB,aAAa;EACb,SAAS;CACV;AACD;EACE,qBAAqB;EACrB,sBAAsB;EACtB,cAAc;EACd,0BAA0B;EAC1B,uCAAuC;UAC/B,+BAA+B;EACvC,uBAAuB;EACvB,YAAY;EACZ,uBAAuB;CACxB;AACD;EACE,mBAAmB;EACnB,qBAAqB;EACrB,sBAAsB;EACtB,cAAc;EACd,0BAA0B;EAC1B,4BAA4B;UACpB,oBAAoB;CAC7B;AACD;EACE,YAAY;EACZ,WAAW;EACX,YAAY;EACZ,2BAA2B;EAC3B,6BAA6B;EAC7B,kCAAkC;UAC1B,0BAA0B;EAClC,sBAAsB;EACtB,oBAAoB;CACrB;AACD;EACE,kCAAkC;UAC1B,0BAA0B;EAClC,oBAAoB;CACrB;AACD;EACE,+BAA+B;EAC/B,qBAAqB;EACrB,eAAe;EACf,uBAAuB;CACxB;AACD;EACE,iBAAiB;CAClB;AACD;;;EAGE,uBAAuB;CACxB;AACD;EACE,8BAA8B;EAC9B,+BAA+B;CAChC;AACD;EACE,uBAAuB;CACxB;AACD;EACE,YAAY;EACZ,WAAW;EACX,YAAY;EACZ,2BAA2B;EAC3B,6BAA6B;EAC7B,kCAAkC;UAC1B,0BAA0B;EAClC,sBAAsB;EACtB,oBAAoB;CACrB;AACD;EACE,kCAAkC;UAC1B,0BAA0B;EAClC,oBAAoB;CACrB;AACD;EACE,uBAAuB;CACxB",file:"coupon.vue",sourcesContent:["\n.main[data-v-07dea7cd] {\n  width: 9.2rem;\n  margin: 0 auto;\n}\n.empty img[data-v-07dea7cd] {\n  width: 2.666667rem;\n  display: block;\n  margin: 4rem auto .266667rem auto;\n}\n.empty p[data-v-07dea7cd] {\n  text-align: center;\n  color: #999;\n  font-size: 0.4rem;\n}\n.couponDo .couponListmain[data-v-07dea7cd] {\n  background: #afbed4;\n  border-radius: .08rem;\n}\n.couponDo .couponListmain .couponList[data-v-07dea7cd] {\n  margin-top: .266667rem;\n  border-radius: .08rem;\n  padding: .4rem;\n  position: relative;\n}\n.couponDo .couponListmain .couponList .coupontop[data-v-07dea7cd] {\n  display: -webkit-box;\n  display: -webkit-flex;\n  display: flex;\n  -webkit-box-align: center;\n  -webkit-align-items: center;\n          align-items: center;\n  position: relative;\n}\n.couponDo .couponListmain .couponList .coupontop .couponPrice[data-v-07dea7cd] {\n  width: 3rem;\n  color: #fff;\n  height: 1.333333rem;\n  line-height: 1.333333rem;\n  font-size: .68rem;\n  text-align: left;\n}\n.couponDo .couponListmain .couponList .coupontop .stroke[data-v-07dea7cd] {\n  position: absolute;\n  width: .533333rem;\n  height: .533333rem;\n  top: 0;\n  right: 0;\n}\n.couponDo .couponListmain .couponList .coupontop .couponTerm[data-v-07dea7cd] {\n  margin-left: -0.733333rem;\n  width: 3.8rem;\n}\n.couponDo .couponListmain .couponList .coupontop .couponTerm p[data-v-07dea7cd] {\n  white-space: wrap;\n}\n.couponDo .couponListmain .couponList .coupontop .couponTerm .couponTermPrice[data-v-07dea7cd] {\n  color: #fff;\n  font-size: 0.48rem;\n}\n.couponDo .couponListmain .couponList .coupontop .couponTerm .couponTermClass[data-v-07dea7cd] {\n  color: #fff;\n  font-size: 0.373333rem;\n}\n.couponDo .couponListmain .couponList .coupontop .coupongo[data-v-07dea7cd] {\n  width: 2.133333rem;\n  height: .8rem;\n  line-height: .8rem;\n  text-align: center;\n  background: #fff;\n  border-radius: .08rem;\n  color: #6d89b0;\n  font-size: .373333rem;\n  position: absolute;\n  top: 0.25rem;\n  right: 0;\n}\n.couponDo .couponListmain .couponList .couponTime[data-v-07dea7cd] {\n  display: -webkit-box;\n  display: -webkit-flex;\n  display: flex;\n  -webkit-box-pack: justify;\n  -webkit-justify-content: space-between;\n          justify-content: space-between;\n  margin-top: .266667rem;\n  color: #fff;\n  font-size: 0.346667rem;\n}\n.couponDo .couponListmain .couponList .couponTime .couponRule[data-v-07dea7cd] {\n  position: relative;\n  display: -webkit-box;\n  display: -webkit-flex;\n  display: flex;\n  -webkit-box-align: center;\n  -webkit-align-items: center;\n          align-items: center;\n}\n.couponDo .couponListmain .couponList .couponTime .couponRule[data-v-07dea7cd]::after {\n  content: '';\n  width: 8px;\n  height: 8px;\n  border-top: 2px solid #fff;\n  border-right: 2px solid #fff;\n  -webkit-transform: rotate(135deg);\n          transform: rotate(135deg);\n  display: inline-block;\n  margin: 0 0 5px 8px;\n}\n.couponDo .couponListmain .couponList .couponTime .couponRule.current[data-v-07dea7cd]::after {\n  -webkit-transform: rotate(-45deg);\n          transform: rotate(-45deg);\n  margin: 5px 0 0 8px;\n}\n.couponDo .couponRuleMain[data-v-07dea7cd] {\n  border-top: 1px dashed #e3e3e3;\n  padding: .2rem .4rem;\n  color: #6d89b0;\n  font-size: 0.346667rem;\n}\n.couponDo.couponExpire .couponListmain[data-v-07dea7cd] {\n  background: #fff;\n}\n.couponDo.couponExpire .couponListmain .couponTermPrice[data-v-07dea7cd],\n.couponDo.couponExpire .couponListmain .couponTermClass[data-v-07dea7cd],\n.couponDo.couponExpire .couponListmain .couponPrice[data-v-07dea7cd] {\n  color: #666 !important;\n}\n.couponDo.couponExpire .couponListmain .stroke[data-v-07dea7cd] {\n  width: 1.333333rem !important;\n  height: 1.333333rem !important;\n}\n.couponDo.couponExpire .couponListmain .couponTime[data-v-07dea7cd] {\n  color: #999 !important;\n}\n.couponDo.couponExpire .couponListmain .couponTime .couponRule[data-v-07dea7cd]::after {\n  content: '';\n  width: 8px;\n  height: 8px;\n  border-top: 2px solid #999;\n  border-right: 2px solid #999;\n  -webkit-transform: rotate(135deg);\n          transform: rotate(135deg);\n  display: inline-block;\n  margin: 0 0 5px 8px;\n}\n.couponDo.couponExpire .couponListmain .couponTime .couponRule.current[data-v-07dea7cd]::after {\n  -webkit-transform: rotate(-45deg);\n          transform: rotate(-45deg);\n  margin: 5px 0 0 8px;\n}\n.couponDo.couponExpire .couponRuleMain[data-v-07dea7cd] {\n  color: #999 !important;\n}\n"],sourceRoot:""}])}});
//# sourceMappingURL=12.112813a5dc3f436a3f24.js.map