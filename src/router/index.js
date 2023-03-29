import Vue from 'vue'
import Router from 'vue-router'
import ai from '@/views/ai/index'
import noe from '@/views/neo/index'

Vue.use(Router)

export const constantRoutes = [
  {
    path: '/',
    name: 'AI',
    component: ai
  },
  {
    path: '/neo',
    name: 'Neo',
    component: noe
  }
]

export default new Router({
  // mode: 'history', // 去掉url中的#
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRoutes
})
