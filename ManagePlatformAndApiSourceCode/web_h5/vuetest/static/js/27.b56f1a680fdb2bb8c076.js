webpackJsonp([27],{"6Kp0":function(t,n,i){var e=i("YgUg");"string"==typeof e&&(e=[[t.i,e,""]]),e.locals&&(t.exports=e.locals);i("rjj0")("793a2694",e,!0,{})},"6XDt":function(t,n,i){var e=i("Sajo");"string"==typeof e&&(e=[[t.i,e,""]]),e.locals&&(t.exports=e.locals);i("rjj0")("515ff533",e,!0,{})},CKbD:function(t,n,i){"use strict";function e(t){i("6Kp0"),i("6XDt")}Object.defineProperty(n,"__esModule",{value:!0});var o=i("7+uW"),a=i("QHDY"),s=i("rHil"),A=i("fBcm"),l=i("b+jt"),r=i("Dild"),c=(a.a,s.a,A.a,l.a,{name:"shoppingCard",components:{Radio:a.a,Group:s.a,Swiper:A.a,SwiperItem:l.a},data:function(){return{bannerlist:[],activitylist:[],id:""}},created:function(){this.getlist()},methods:{getlist:function(){var t=this;Object(r.c)().then(function(n){0===n.data.errorcode?(n.data.data.bannerlist.map(function(n,i){({}).img=n.picurl,t.bannerlist.push(n.picurl)}),t.activitylist=n.data.data.activitylist):t.$vux.toast.text(n.data.errormsg,"middle")}).catch(function(n){t.$vux.toast.text("请求出错！","middle")})},goall:function(t){this.$router.push({path:"/showphoto/actdetail",query:{id:t}})}},mounted:function(){o.a.wechat.ready(function(){o.a.wechat.checkJsApi({jsApiList:["chooseImage","previewImage","uploadImage","downloadImage","onMenuShareTimeline","onMenuShareAppMessage","onMenuShareQQ","scanQRCode"],success:function(t){console.log(t)}});localStorage.getItem("shareid");o.a.wechat.onMenuShareTimeline({title:"晒图征集活动",link:"https://m.hecate.edifier.com/weixin/index.html?#/showphoto",imgUrl:"https://m.hecate.edifier.com/weixin/static/images/sharelogo.jpg",success:function(t){}}),o.a.wechat.onMenuShareAppMessage({title:"晒图征集活动",desc:"",link:"https://m.hecate.edifier.com/weixin/index.html?#/showphoto",imgUrl:"https://m.hecate.edifier.com/weixin/static/images/sharelogo.jpg",success:function(t){}})})}}),f=function(){var t=this,n=t.$createElement,i=t._self._c||n;return i("div",{attrs:{id:"showphoto"}},[t.bannerlist.length>0?i("swiper",{staticStyle:{"margin-bottom":".266667rem"},attrs:{"aspect-ratio":320/750,auto:!0,loop:!0,"dots-position":"center","show-dots":!1}},t._l(t.bannerlist,function(t,n){return i("swiper-item",{key:n,staticClass:"swiper-demo-img"},[i("img",{attrs:{src:t}})])})):t._e(),t._v(" "),i("div",{staticClass:"main"},t._l(t.activitylist,function(n,e){return i("div",{key:e,staticClass:"imglist",on:{click:function(i){t.goall(n.id)}}},[i("img",{attrs:{src:n.pic,width:"100%"}}),t._v(" "),i("div",{staticClass:"titlemain"},[i("div",{staticClass:"titlemainflex"},[i("div",{staticClass:"big"},[t._v(t._s(n.title))]),t._v(" "),i("div",{staticClass:"small"},[t._v(t._s(n.subtitle))])])]),t._v(" "),1==n.status?i("div",{staticClass:"jieshu"},[t._v("活动已结束")]):t._e()])}))],1)},d=[],m={render:f,staticRenderFns:d},p=m,h=i("VU/8"),B=e,C=h(c,p,!1,B,"data-v-5fa0b729",null);n.default=C.exports},Sajo:function(t,n,i){n=t.exports=i("FZ+f")(!0),n.push([t.i,"\n#showphoto .vux-icon-dot{\n    background-color: #fff !important;\n    opacity: .5;\n}\n#showphoto .vux-icon-dot.active{\n  background-color: #fff !important;\n  opacity: 1;\n}\n#showphoto .swiper-demo-img img{\n  width: 100%;\n}\n","",{version:3,sources:["/Users/binyang/work/edifier/jing_code/waptest/src/views/showphoto/index.vue"],names:[],mappings:";AACA;IACI,kCAAkC;IAClC,YAAY;CACf;AACD;EACE,kCAAkC;EAClC,WAAW;CACZ;AACD;EACE,YAAY;CACb",file:"index.vue",sourcesContent:["\n#showphoto .vux-icon-dot{\n    background-color: #fff !important;\n    opacity: .5;\n}\n#showphoto .vux-icon-dot.active{\n  background-color: #fff !important;\n  opacity: 1;\n}\n#showphoto .swiper-demo-img img{\n  width: 100%;\n}\n"],sourceRoot:""}])},YgUg:function(t,n,i){n=t.exports=i("FZ+f")(!0),n.push([t.i,"\n#showphoto .main[data-v-5fa0b729] {\n  width: 9.5rem;\n  margin: 0 auto;\n}\n#showphoto .main .imglist[data-v-5fa0b729] {\n  border-radius: .133333rem;\n  overflow: hidden;\n  position: relative;\n  margin-bottom: .266667rem;\n}\n#showphoto .main .imglist img[data-v-5fa0b729] {\n  display: block;\n}\n#showphoto .main .imglist .titlemain[data-v-5fa0b729] {\n  position: absolute;\n  top: 0;\n  display: -webkit-box;\n  display: -webkit-flex;\n  display: flex;\n  left: 0;\n  width: 100%;\n  height: 100%;\n  -webkit-box-align: center;\n  -webkit-align-items: center;\n          align-items: center;\n}\n#showphoto .main .imglist .titlemain .titlemainflex[data-v-5fa0b729] {\n  display: -webkit-box;\n  display: -webkit-flex;\n  display: flex;\n  -webkit-box-pack: start;\n  -webkit-justify-content: flex-start;\n          justify-content: flex-start;\n  -webkit-flex-wrap: wrap;\n          flex-wrap: wrap;\n  -webkit-box-orient: vertical;\n  -webkit-box-direction: normal;\n  -webkit-flex-direction: column;\n          flex-direction: column;\n}\n#showphoto .main .imglist .titlemain .big[data-v-5fa0b729] {\n  height: 1.066667rem;\n  line-height: 1.066667rem;\n  font-size: .64rem;\n  color: #ffffff;\n  font-weight: bold;\n  padding-left: .666667rem;\n}\n#showphoto .main .imglist .titlemain .small[data-v-5fa0b729] {\n  font-size: .373333rem;\n  color: #ffffff;\n  padding-left: .666667rem;\n}\n#showphoto .main .imglist .jieshu[data-v-5fa0b729] {\n  position: absolute;\n  width: 100%;\n  height: 100%;\n  line-height: 100%;\n  background: rgba(0, 0, 0, 0.6);\n  color: #fff;\n  font-size: .64rem;\n  text-align: center;\n  top: 0;\n  left: 0;\n  display: -webkit-box;\n  display: -webkit-flex;\n  display: flex;\n  -webkit-box-align: center;\n  -webkit-align-items: center;\n          align-items: center;\n  -webkit-box-pack: center;\n  -webkit-justify-content: center;\n          justify-content: center;\n  border-radius: .133333rem;\n  overflow: hidden;\n}\n","",{version:3,sources:["/Users/binyang/work/edifier/jing_code/waptest/src/views/showphoto/index.vue"],names:[],mappings:";AACA;EACE,cAAc;EACd,eAAe;CAChB;AACD;EACE,0BAA0B;EAC1B,iBAAiB;EACjB,mBAAmB;EACnB,0BAA0B;CAC3B;AACD;EACE,eAAe;CAChB;AACD;EACE,mBAAmB;EACnB,OAAO;EACP,qBAAqB;EACrB,sBAAsB;EACtB,cAAc;EACd,QAAQ;EACR,YAAY;EACZ,aAAa;EACb,0BAA0B;EAC1B,4BAA4B;UACpB,oBAAoB;CAC7B;AACD;EACE,qBAAqB;EACrB,sBAAsB;EACtB,cAAc;EACd,wBAAwB;EACxB,oCAAoC;UAC5B,4BAA4B;EACpC,wBAAwB;UAChB,gBAAgB;EACxB,6BAA6B;EAC7B,8BAA8B;EAC9B,+BAA+B;UACvB,uBAAuB;CAChC;AACD;EACE,oBAAoB;EACpB,yBAAyB;EACzB,kBAAkB;EAClB,eAAe;EACf,kBAAkB;EAClB,yBAAyB;CAC1B;AACD;EACE,sBAAsB;EACtB,eAAe;EACf,yBAAyB;CAC1B;AACD;EACE,mBAAmB;EACnB,YAAY;EACZ,aAAa;EACb,kBAAkB;EAClB,+BAA+B;EAC/B,YAAY;EACZ,kBAAkB;EAClB,mBAAmB;EACnB,OAAO;EACP,QAAQ;EACR,qBAAqB;EACrB,sBAAsB;EACtB,cAAc;EACd,0BAA0B;EAC1B,4BAA4B;UACpB,oBAAoB;EAC5B,yBAAyB;EACzB,gCAAgC;UACxB,wBAAwB;EAChC,0BAA0B;EAC1B,iBAAiB;CAClB",file:"index.vue",sourcesContent:["\n#showphoto .main[data-v-5fa0b729] {\n  width: 9.5rem;\n  margin: 0 auto;\n}\n#showphoto .main .imglist[data-v-5fa0b729] {\n  border-radius: .133333rem;\n  overflow: hidden;\n  position: relative;\n  margin-bottom: .266667rem;\n}\n#showphoto .main .imglist img[data-v-5fa0b729] {\n  display: block;\n}\n#showphoto .main .imglist .titlemain[data-v-5fa0b729] {\n  position: absolute;\n  top: 0;\n  display: -webkit-box;\n  display: -webkit-flex;\n  display: flex;\n  left: 0;\n  width: 100%;\n  height: 100%;\n  -webkit-box-align: center;\n  -webkit-align-items: center;\n          align-items: center;\n}\n#showphoto .main .imglist .titlemain .titlemainflex[data-v-5fa0b729] {\n  display: -webkit-box;\n  display: -webkit-flex;\n  display: flex;\n  -webkit-box-pack: start;\n  -webkit-justify-content: flex-start;\n          justify-content: flex-start;\n  -webkit-flex-wrap: wrap;\n          flex-wrap: wrap;\n  -webkit-box-orient: vertical;\n  -webkit-box-direction: normal;\n  -webkit-flex-direction: column;\n          flex-direction: column;\n}\n#showphoto .main .imglist .titlemain .big[data-v-5fa0b729] {\n  height: 1.066667rem;\n  line-height: 1.066667rem;\n  font-size: .64rem;\n  color: #ffffff;\n  font-weight: bold;\n  padding-left: .666667rem;\n}\n#showphoto .main .imglist .titlemain .small[data-v-5fa0b729] {\n  font-size: .373333rem;\n  color: #ffffff;\n  padding-left: .666667rem;\n}\n#showphoto .main .imglist .jieshu[data-v-5fa0b729] {\n  position: absolute;\n  width: 100%;\n  height: 100%;\n  line-height: 100%;\n  background: rgba(0, 0, 0, 0.6);\n  color: #fff;\n  font-size: .64rem;\n  text-align: center;\n  top: 0;\n  left: 0;\n  display: -webkit-box;\n  display: -webkit-flex;\n  display: flex;\n  -webkit-box-align: center;\n  -webkit-align-items: center;\n          align-items: center;\n  -webkit-box-pack: center;\n  -webkit-justify-content: center;\n          justify-content: center;\n  border-radius: .133333rem;\n  overflow: hidden;\n}\n"],sourceRoot:""}])}});
//# sourceMappingURL=27.b56f1a680fdb2bb8c076.js.map