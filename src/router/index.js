import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

const routerOptions = [
  { name: 'home', path: '/', component: 'home' },
  { name: 'book', path: '/book/:index', component: 'book' },
  { path: '*', component: 'error-404' }
]

const routes = routerOptions.map(route => {
  return {
    ...route,
    component: () => import(`@/views/${route.component}.vue`)
  }
})

const router = new Router({
  mode: 'history',
  routes
})

export default router
