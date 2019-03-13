import Vue from 'vue'
import App from './app'
import router from './router'

import data from '@/data'

Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#app',
  // Router is for urls to share.
  router,
  components: { App },
  template: '<App/>',
  // Small app can afford to pranks.
  data () {
    return {
      book: data.book.reverse(),
      title: document.title
    }
  }
})
