webpackJsonp([16],{JCc8:function(t,e,n){"use strict";function a(t){n("SvKv")}Object.defineProperty(e,"__esModule",{value:!0});var r=n("mvHQ"),i=n.n(r),o=n("odqc"),s=n("Znkm"),c=n("fBcm"),l=n("b+jt"),d=n("e66H"),A=n("/CG/"),m=n("8pLc"),u=n("wC/b"),C=n("vMJZ"),h=(o.a,s.a,c.a,l.a,A.a,u.a,d.a,m.a,{name:"uc-comments",data:function(){return{noDataShow:!1,curTab:0,selectItem:"",postData:{page:1,pagenum:50},tabList:[{label:"全部评价",val:"all"},{label:"待评价",val:0},{label:"已评价",val:1}],raterNum:5,noData:{txt:"目前还没发现相关评论呢",img:"static/images/noOrder.png"},curData:[]}},computed:{},created:function(){this.$route.query.type>=0?(console.log(this.$route.query.type),this.curTab=Number(this.$route.query.type),this.selectItem=Number(this.$route.query.type),this.postData.status=this.$route.query.type,this.handleGetList()):this.handleGetList()},components:{Tab:o.a,TabItem:s.a,Swiper:c.a,SwiperItem:l.a,ShopBtn:A.a,shopList:u.a,Rater:d.a,nodata:m.a},methods:{handleGetList:function(){var t=this;this.$vux.loading.show(),this.curData=[],this.noDataShow=!1,"all"!==this.selectItem?this.postData.status=this.selectItem:this.postData.status="",Object(C.q)(this.postData).then(function(e){t.$vux.loading.hide(),t.noDataShow=!0,0===e.data.errorcode?(t.curData=e.data.data.commentlist,console.log(e.data.data.commentlist)):t.$vux.toast.text(e.data.errormsg,"middle")}).catch(function(e){t.noDataShow=!0,t.$vux.loading.hide(),console.log(e),t.$vux.toast.text("网络异常！","middle")})},handleDetail:function(t){0!==t.status&&this.$router.push({name:"uc-commentsDetail",query:{id:t.skuid}})},handleSelectItem:function(t){this.postData.page=1,this.selectItem=t.val,this.postData.status=t.val,console.log(this.selectItem),this.handleGetList()},handleComment:function(t){console.log(t),this.$router.push({name:"uc-submitcomments",query:{item:encodeURIComponent(i()(t))}})},test:function(){console.log(2323)}}}),p=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"myorder-wrap",attrs:{id:"uc-comments"}},[n("div",{staticClass:"myorder-tab"},[n("tab",{attrs:{"active-color":"#008fe2","scroll-threshold":3,"line-width":2,"custom-bar-width":"44px"},model:{value:t.curTab,callback:function(e){t.curTab=e},expression:"curTab"}},t._l(t.tabList,function(e,a){return n("tab-item",{key:a,staticClass:"vux-center",attrs:{selected:t.selectItem===e.val},on:{"on-item-click":function(n){t.handleSelectItem(e)},click:function(n){t.selectItem=e.val}}},[t._v(t._s(e.label))])})),t._v(" "),t._l(t.tabList,function(e,a){return n("div",{directives:[{name:"show",rawName:"v-show",value:t.curTab===a,expression:"curTab === index"}],key:a,staticClass:"myorder-container"},[t._l(t.curData,function(e,a){return n("div",{key:a,staticClass:"myorder-container-item"},[n("div",{staticClass:"list-wrap"},[t.curData.length>0?n("div",{staticClass:"list-wrap-main"},[n("div",{staticClass:"headerwrap"},[n("div",{staticClass:"headerCon",staticStyle:{"border-bottom":"1px solid #d8d8d8"}},[n("p",[t._v(t._s(e.ordertime))]),t._v(" "),0===e.status?n("p",[t._v("未评价")]):n("p",{staticStyle:{color:"#333333"}},[t._v("已评价")])])]),t._v(" "),n("div",{staticClass:"list-wrap-container item-borde",on:{click:function(n){n.stopPropagation(),t.handleDetail(e)}}},[n("div",{staticClass:"order"},[n("div",{staticClass:"main"},[t.curData.length>0?n("ul",{staticClass:"order_list"},[n("li",[n("div",{staticClass:"ordermain"},[n("img",{staticStyle:{"line-height":"2.186667rem",color:"#333333"},attrs:{src:e.skuimg,width:"100%",alt:""}})]),t._v(" "),n("div",{staticClass:"orderprice"},[n("div",[n("span",[t._v(t._s(e.productname))]),n("span",[t._v("￥"+t._s(e.price))])]),t._v(" "),n("div",{staticClass:"orderpricenum"},[n("div",[t._v(t._s(e.skuname))]),n("div",[t._v("×"+t._s(e.num))])])])])]):t._e()])])]),t._v(" "),n("div",{staticClass:"footerwrap"},[n("div",{staticClass:"footer-default-container"},[0===e.status?n("shop-btn",{attrs:{btntext:"去评价",fontColor:"#ff6701",defaultBorderColor:"#ff6701"},on:{onClick:function(n){t.handleComment(e)}}}):t._e()],1)])]):t._e()])])}),t._v(" "),n("div",{directives:[{name:"show",rawName:"v-show",value:t.curData.length<1&&t.noDataShow,expression:"curData.length < 1 && noDataShow"}],staticStyle:{height:"100px",background:"red"}},[n("nodata",{attrs:{tipsTxt:t.noData.txt,tipsImg:!!t.noData.img&&t.noData.img}})],1)],2)})],2)])},v=[],f={render:p,staticRenderFns:v},B=f,g=n("VU/8"),b=a,x=g(h,B,!1,b,"data-v-448e7572",null);e.default=x.exports},SvKv:function(t,e,n){var a=n("x3KH");"string"==typeof a&&(a=[[t.i,a,""]]),a.locals&&(t.exports=a.locals);n("rjj0")("218fa962",a,!0,{})},e66H:function(t,e,n){"use strict";function a(t){n("rI5v")}var r=(Number,Number,Number,String,Boolean,String,String,Number,Number,{name:"rater",created:function(){this.currentValue=parseInt(this.value)},mounted:function(){this.updateStyle()},props:{min:{type:Number,default:0},max:{type:Number,default:5},value:{type:[Number,String],default:0},disabled:Boolean,star:{type:String,default:"★"},activeColor:{type:String,default:"#fc6"},margin:{type:Number,default:2},fontSize:{type:Number,default:25}},computed:{sliceValue:function(){var t=this.currentValue.toFixed(2).split(".");return 1===t.length?[t[0],0]:t},cutIndex:function(){return 1*this.sliceValue[0]},cutPercent:function(){return 1*this.sliceValue[1]}},methods:{handleClick:function(t,e){this.disabled&&!e||(this.currentValue===t+1?(this.currentValue=t<this.min?this.min:t,this.updateStyle()):this.currentValue=t+1<this.min?this.min:t+1)},updateStyle:function(){for(var t=0;t<this.max;t++)t<=this.currentValue-1?this.$set(this.colors,t,this.activeColor):this.$set(this.colors,t,"#ccc")}},data:function(){return{colors:[],currentValue:0}},watch:{currentValue:function(t){this.updateStyle(),this.$emit("input",t)},value:function(t){this.currentValue=t}}}),i=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"vux-rater"},[n("input",{directives:[{name:"model",rawName:"v-model",value:t.currentValue,expression:"currentValue"}],staticStyle:{display:"none"},domProps:{value:t.currentValue},on:{input:function(e){e.target.composing||(t.currentValue=e.target.value)}}}),t._v(" "),t._l(t.max,function(e){return n("a",{staticClass:"vux-rater-box",class:{"is-active":t.currentValue>e-1},style:{color:t.colors&&t.colors[e-1]?t.colors[e-1]:"#ccc",marginRight:t.margin+"px",fontSize:t.fontSize+"px",width:t.fontSize+"px",height:t.fontSize+"px",lineHeight:t.fontSize+"px"},on:{click:function(n){t.handleClick(e-1)}}},[n("span",{staticClass:"vux-rater-inner"},[n("span",{domProps:{innerHTML:t._s(t.star)}}),t.cutPercent>0&&t.cutIndex===e-1?n("span",{staticClass:"vux-rater-outer",style:{color:t.activeColor,width:t.cutPercent+"%"},domProps:{innerHTML:t._s(t.star)}}):t._e()])])})],2)},o=[],s={render:i,staticRenderFns:o},c=s,l=n("VU/8"),d=a,A=l(r,c,!1,d,null,null);e.a=A.exports},"gp++":function(t,e,n){e=t.exports=n("FZ+f")(!0),e.push([t.i,"\n.vux-rater {\n  text-align: left;\n  display: inline-block;\n  line-height: normal;\n}\n.vux-rater a {\n  display: inline-block;\n  text-align: center;\n  cursor: pointer;\n  color: #ccc;\n}\n.vux-rater a:last-child {\n  padding-right: 2px!important;\n  margin-right: 0px!important;\n}\n.vux-rater a:hover {\n  color: #ffdd99;\n}\n.vux-rater a.is-disabled {\n  color: #ccc !important;\n  cursor: not-allowed;\n}\n.vux-rater-box {\n  position: relative;\n}\n.vux-rater-inner {\n  position: relative;\n  display: inline-block;\n}\n.vux-rater-outer {\n  position: absolute;\n  left: 0;\n  top: 0;\n  display: inline-block;\n  overflow: hidden;\n}\n","",{version:3,sources:["/Users/binyang/work/edifier/jing_code/waptest/node_modules/vux/src/components/rater/index.vue"],names:[],mappings:";AACA;EACE,iBAAiB;EACjB,sBAAsB;EACtB,oBAAoB;CACrB;AACD;EACE,sBAAsB;EACtB,mBAAmB;EACnB,gBAAgB;EAChB,YAAY;CACb;AACD;EACE,6BAA6B;EAC7B,4BAA4B;CAC7B;AACD;EACE,eAAe;CAChB;AACD;EACE,uBAAuB;EACvB,oBAAoB;CACrB;AACD;EACE,mBAAmB;CACpB;AACD;EACE,mBAAmB;EACnB,sBAAsB;CACvB;AACD;EACE,mBAAmB;EACnB,QAAQ;EACR,OAAO;EACP,sBAAsB;EACtB,iBAAiB;CAClB",file:"index.vue",sourcesContent:["\n.vux-rater {\n  text-align: left;\n  display: inline-block;\n  line-height: normal;\n}\n.vux-rater a {\n  display: inline-block;\n  text-align: center;\n  cursor: pointer;\n  color: #ccc;\n}\n.vux-rater a:last-child {\n  padding-right: 2px!important;\n  margin-right: 0px!important;\n}\n.vux-rater a:hover {\n  color: #ffdd99;\n}\n.vux-rater a.is-disabled {\n  color: #ccc !important;\n  cursor: not-allowed;\n}\n.vux-rater-box {\n  position: relative;\n}\n.vux-rater-inner {\n  position: relative;\n  display: inline-block;\n}\n.vux-rater-outer {\n  position: absolute;\n  left: 0;\n  top: 0;\n  display: inline-block;\n  overflow: hidden;\n}\n"],sourceRoot:""}])},rI5v:function(t,e,n){var a=n("gp++");"string"==typeof a&&(a=[[t.i,a,""]]),a.locals&&(t.exports=a.locals);n("rjj0")("2f11173a",a,!0,{})},x3KH:function(t,e,n){e=t.exports=n("FZ+f")(!0),e.push([t.i,"\nbody[data-v-448e7572] {\n  background: #f7f7f7;\n}\n.weui-dialog__btn_primary[data-v-448e7572] {\n  color: #008fe2;\n}\n#uc-comments[data-v-448e7572] .myorder-tab {\n  width: 100%;\n  height: 1.066667rem;\n  font-size: 14px;\n  font-family: PingFang-SC-Regular;\n}\n#uc-comments[data-v-448e7572] .myorder-tab .myorder-container {\n    width: 100%;\n    background: #f7f7f7;\n}\n#uc-comments[data-v-448e7572] .myorder-tab .myorder-container-item {\n      width: 100%;\n      margin-top: .266667rem;\n}\n#uc-comments[data-v-448e7572] .order {\n  background: #fff;\n}\n#uc-comments[data-v-448e7572] .order .main .order_list li {\n    display: -webkit-box;\n    display: -webkit-flex;\n    display: flex;\n    -webkit-box-pack: justify;\n    -webkit-justify-content: space-between;\n            justify-content: space-between;\n    padding: .266667rem 0;\n    border-bottom: 1px solid #d8d8d8;\n}\n#uc-comments[data-v-448e7572] .order .main .order_list li:last-child {\n      border-bottom: 0;\n}\n#uc-comments[data-v-448e7572] .order .main .order_list li .ordermain {\n      width: 18%;\n}\n#uc-comments[data-v-448e7572] .order .main .order_list li .orderprice {\n      width: 78%;\n}\n#uc-comments[data-v-448e7572] .order .main .order_list li .orderprice > div {\n        width: 100%;\n        display: -webkit-box;\n        display: -webkit-flex;\n        display: flex;\n        -webkit-box-pack: justify;\n        -webkit-justify-content: space-between;\n                justify-content: space-between;\n        color: #333;\n        font-size: 0.42667rem;\n}\n#uc-comments[data-v-448e7572] .order .main .order_list li .orderprice .orderpricenum {\n        margin-top: .373333rem;\n        color: #999;\n        font-size: 0.4rem;\n}\n#uc-comments[data-v-448e7572] .listheaderCon {\n  border-bottom: 1px solid #d8d8d8;\n  height: 1.333333rem;\n}\n#uc-comments[data-v-448e7572] .listheaderCon p {\n    width: auto;\n    float: left;\n}\n#uc-comments[data-v-448e7572] .listheaderCon p:first-child {\n    text-align: left;\n}\n#uc-comments[data-v-448e7572] .listheaderCon p:nth-child(2) {\n    font-size: 15px;\n    color: #008fe2;\n    text-align: right;\n    float: right;\n}\n#uc-comments[data-v-448e7572] .listheaderCon .yield {\n    color: #333333 !important;\n}\n#uc-comments[data-v-448e7572] .listheaderCon .vux-rater {\n    margin-left: 0.4rem !important;\n}\n#uc-comments[data-v-448e7572] .listheaderCon .vux-rater-box, #uc-comments[data-v-448e7572] .listheaderCon .vux-rater-inner, #uc-comments[data-v-448e7572] .listheaderCon .vux-rater-inner span {\n    width: 0.42667rem !important;\n    height: 0.42667rem !important;\n    font-size: 15px !important;\n    margin-right: 0.18667rem !important;\n}\n#uc-comments[data-v-448e7572] .footer-container {\n  width: 100%;\n  height: 1.33333rem;\n  border-top: 1px solid #d8d8d8;\n}\n#uc-comments[data-v-448e7572] .footer-container div {\n    margin: .266667rem 0rem .266667rem 0rem;\n    float: right;\n}\n#uc-comments[data-v-448e7572] .list-wrap {\n  width: 100%;\n  height: 100%;\n  box-sizing: border-box;\n  background-color: #fff;\n}\n#uc-comments[data-v-448e7572] .list-wrap .headerwrap, #uc-comments[data-v-448e7572] .list-wrap .footerwrap {\n    height: auto;\n    width: 100%;\n    background-color: #fff;\n    line-height: 1.33333rem;\n    font-size: 13px;\n    color: #666666;\n    letter-spacing: 0;\n    text-align: left;\n}\n#uc-comments[data-v-448e7572] .list-wrap .headerCon {\n    width: 100%;\n    height: 1.33333rem;\n}\n#uc-comments[data-v-448e7572] .list-wrap .headerCon p {\n      overflow: hidden;\n      text-overflow: ellipsis;\n      width: 50%;\n      float: left;\n}\n#uc-comments[data-v-448e7572] .list-wrap .headerCon p:first-child {\n      text-align: left;\n}\n#uc-comments[data-v-448e7572] .list-wrap .headerCon p:nth-child(2) {\n      font-size: 15px;\n      color: #ff6701;\n      text-align: right;\n}\n#uc-comments[data-v-448e7572] .list-wrap-main {\n    width: 92%;\n    margin: 0 auto;\n}\n#uc-comments[data-v-448e7572] .list-wrap-container {\n    width: 100%;\n    min-height: .8rem;\n}\n#uc-comments[data-v-448e7572] .list-wrap .item-border ul {\n    border-bottom: 0px solid #d8d8d8;\n}\n#uc-comments[data-v-448e7572] .footer-default-container {\n  width: 100%;\n  height: 1.33333rem;\n  border-top: 1px solid #d8d8d8;\n}\n#uc-comments[data-v-448e7572] .footer-default-container div {\n    margin: .266667rem .4rem .266667rem 0rem;\n    float: right;\n}\n","",{version:3,sources:["/Users/binyang/work/edifier/jing_code/waptest/src/views/user/comments.vue"],names:[],mappings:";AACA;EACE,oBAAoB;CACrB;AACD;EACE,eAAe;CAChB;AACD;EACE,YAAY;EACZ,oBAAoB;EACpB,gBAAgB;EAChB,iCAAiC;CAClC;AACD;IACI,YAAY;IACZ,oBAAoB;CACvB;AACD;MACM,YAAY;MACZ,uBAAuB;CAC5B;AACD;EACE,iBAAiB;CAClB;AACD;IACI,qBAAqB;IACrB,sBAAsB;IACtB,cAAc;IACd,0BAA0B;IAC1B,uCAAuC;YAC/B,+BAA+B;IACvC,sBAAsB;IACtB,iCAAiC;CACpC;AACD;MACM,iBAAiB;CACtB;AACD;MACM,WAAW;CAChB;AACD;MACM,WAAW;CAChB;AACD;QACQ,YAAY;QACZ,qBAAqB;QACrB,sBAAsB;QACtB,cAAc;QACd,0BAA0B;QAC1B,uCAAuC;gBAC/B,+BAA+B;QACvC,YAAY;QACZ,sBAAsB;CAC7B;AACD;QACQ,uBAAuB;QACvB,YAAY;QACZ,kBAAkB;CACzB;AACD;EACE,iCAAiC;EACjC,oBAAoB;CACrB;AACD;IACI,YAAY;IACZ,YAAY;CACf;AACD;IACI,iBAAiB;CACpB;AACD;IACI,gBAAgB;IAChB,eAAe;IACf,kBAAkB;IAClB,aAAa;CAChB;AACD;IACI,0BAA0B;CAC7B;AACD;IACI,+BAA+B;CAClC;AACD;IACI,6BAA6B;IAC7B,8BAA8B;IAC9B,2BAA2B;IAC3B,oCAAoC;CACvC;AACD;EACE,YAAY;EACZ,mBAAmB;EACnB,8BAA8B;CAC/B;AACD;IACI,wCAAwC;IACxC,aAAa;CAChB;AACD;EACE,YAAY;EACZ,aAAa;EACb,uBAAuB;EACvB,uBAAuB;CACxB;AACD;IACI,aAAa;IACb,YAAY;IACZ,uBAAuB;IACvB,wBAAwB;IACxB,gBAAgB;IAChB,eAAe;IACf,kBAAkB;IAClB,iBAAiB;CACpB;AACD;IACI,YAAY;IACZ,mBAAmB;CACtB;AACD;MACM,iBAAiB;MACjB,wBAAwB;MACxB,WAAW;MACX,YAAY;CACjB;AACD;MACM,iBAAiB;CACtB;AACD;MACM,gBAAgB;MAChB,eAAe;MACf,kBAAkB;CACvB;AACD;IACI,WAAW;IACX,eAAe;CAClB;AACD;IACI,YAAY;IACZ,kBAAkB;CACrB;AACD;IACI,iCAAiC;CACpC;AACD;EACE,YAAY;EACZ,mBAAmB;EACnB,8BAA8B;CAC/B;AACD;IACI,yCAAyC;IACzC,aAAa;CAChB",file:"comments.vue",sourcesContent:["\nbody[data-v-448e7572] {\n  background: #f7f7f7;\n}\n.weui-dialog__btn_primary[data-v-448e7572] {\n  color: #008fe2;\n}\n#uc-comments[data-v-448e7572] .myorder-tab {\n  width: 100%;\n  height: 1.066667rem;\n  font-size: 14px;\n  font-family: PingFang-SC-Regular;\n}\n#uc-comments[data-v-448e7572] .myorder-tab .myorder-container {\n    width: 100%;\n    background: #f7f7f7;\n}\n#uc-comments[data-v-448e7572] .myorder-tab .myorder-container-item {\n      width: 100%;\n      margin-top: .266667rem;\n}\n#uc-comments[data-v-448e7572] .order {\n  background: #fff;\n}\n#uc-comments[data-v-448e7572] .order .main .order_list li {\n    display: -webkit-box;\n    display: -webkit-flex;\n    display: flex;\n    -webkit-box-pack: justify;\n    -webkit-justify-content: space-between;\n            justify-content: space-between;\n    padding: .266667rem 0;\n    border-bottom: 1px solid #d8d8d8;\n}\n#uc-comments[data-v-448e7572] .order .main .order_list li:last-child {\n      border-bottom: 0;\n}\n#uc-comments[data-v-448e7572] .order .main .order_list li .ordermain {\n      width: 18%;\n}\n#uc-comments[data-v-448e7572] .order .main .order_list li .orderprice {\n      width: 78%;\n}\n#uc-comments[data-v-448e7572] .order .main .order_list li .orderprice > div {\n        width: 100%;\n        display: -webkit-box;\n        display: -webkit-flex;\n        display: flex;\n        -webkit-box-pack: justify;\n        -webkit-justify-content: space-between;\n                justify-content: space-between;\n        color: #333;\n        font-size: 0.42667rem;\n}\n#uc-comments[data-v-448e7572] .order .main .order_list li .orderprice .orderpricenum {\n        margin-top: .373333rem;\n        color: #999;\n        font-size: 0.4rem;\n}\n#uc-comments[data-v-448e7572] .listheaderCon {\n  border-bottom: 1px solid #d8d8d8;\n  height: 1.333333rem;\n}\n#uc-comments[data-v-448e7572] .listheaderCon p {\n    width: auto;\n    float: left;\n}\n#uc-comments[data-v-448e7572] .listheaderCon p:first-child {\n    text-align: left;\n}\n#uc-comments[data-v-448e7572] .listheaderCon p:nth-child(2) {\n    font-size: 15px;\n    color: #008fe2;\n    text-align: right;\n    float: right;\n}\n#uc-comments[data-v-448e7572] .listheaderCon .yield {\n    color: #333333 !important;\n}\n#uc-comments[data-v-448e7572] .listheaderCon .vux-rater {\n    margin-left: 0.4rem !important;\n}\n#uc-comments[data-v-448e7572] .listheaderCon .vux-rater-box, #uc-comments[data-v-448e7572] .listheaderCon .vux-rater-inner, #uc-comments[data-v-448e7572] .listheaderCon .vux-rater-inner span {\n    width: 0.42667rem !important;\n    height: 0.42667rem !important;\n    font-size: 15px !important;\n    margin-right: 0.18667rem !important;\n}\n#uc-comments[data-v-448e7572] .footer-container {\n  width: 100%;\n  height: 1.33333rem;\n  border-top: 1px solid #d8d8d8;\n}\n#uc-comments[data-v-448e7572] .footer-container div {\n    margin: .266667rem 0rem .266667rem 0rem;\n    float: right;\n}\n#uc-comments[data-v-448e7572] .list-wrap {\n  width: 100%;\n  height: 100%;\n  box-sizing: border-box;\n  background-color: #fff;\n}\n#uc-comments[data-v-448e7572] .list-wrap .headerwrap, #uc-comments[data-v-448e7572] .list-wrap .footerwrap {\n    height: auto;\n    width: 100%;\n    background-color: #fff;\n    line-height: 1.33333rem;\n    font-size: 13px;\n    color: #666666;\n    letter-spacing: 0;\n    text-align: left;\n}\n#uc-comments[data-v-448e7572] .list-wrap .headerCon {\n    width: 100%;\n    height: 1.33333rem;\n}\n#uc-comments[data-v-448e7572] .list-wrap .headerCon p {\n      overflow: hidden;\n      text-overflow: ellipsis;\n      width: 50%;\n      float: left;\n}\n#uc-comments[data-v-448e7572] .list-wrap .headerCon p:first-child {\n      text-align: left;\n}\n#uc-comments[data-v-448e7572] .list-wrap .headerCon p:nth-child(2) {\n      font-size: 15px;\n      color: #ff6701;\n      text-align: right;\n}\n#uc-comments[data-v-448e7572] .list-wrap-main {\n    width: 92%;\n    margin: 0 auto;\n}\n#uc-comments[data-v-448e7572] .list-wrap-container {\n    width: 100%;\n    min-height: .8rem;\n}\n#uc-comments[data-v-448e7572] .list-wrap .item-border ul {\n    border-bottom: 0px solid #d8d8d8;\n}\n#uc-comments[data-v-448e7572] .footer-default-container {\n  width: 100%;\n  height: 1.33333rem;\n  border-top: 1px solid #d8d8d8;\n}\n#uc-comments[data-v-448e7572] .footer-default-container div {\n    margin: .266667rem .4rem .266667rem 0rem;\n    float: right;\n}\n"],sourceRoot:""}])}});
//# sourceMappingURL=16.23f7745fd7eeb4101018.js.map