import Vue from 'vue'
import App from './App'
import router from './router'
import element from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import axios from 'axios'
import VueAxios from 'vue-axios'

// import 'katex/dist/katex.min.css'
// import '@/styles/lib/tailwind.css'
import '@/assets/css/highlight.less'
// import '@/styles/lib/github-markdown.less'

// import Vant from "vant";

//定义全局变量
Vue.use(VueAxios, axios)


Vue.config.productionTip = false
Vue.use(element)
// Vue.use(Vant)

new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>'
})
