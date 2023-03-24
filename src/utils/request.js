import axios from 'axios'
import { Toast, Notify } from 'vant'
import { tansParams } from '@/utils/ruoyi'
import cache from '@/plugins/cache'

// eslint-disable-next-line no-unused-vars
let loadingInstance
let needLoadingRequestCount = 0

// 显示loading
function showFullScreenLoading() {
  if (needLoadingRequestCount === 0) {
    loadingInstance = Toast.loading({
      duration: 0, // 持续展示 toast
      forbidClick: true,
      message: ''
    })
  }
  needLoadingRequestCount++
}

// 关闭loading
function tryHideFullScreenLoading() {
  if (needLoadingRequestCount <= 0) return
  needLoadingRequestCount--
  if (needLoadingRequestCount === 0) {
    setTimeout(tryCloseLoading, 300)// 300ms 间隔内的 loading 合并为一次
  }
}

// 尝试关闭loading
const tryCloseLoading = function () {
  if (needLoadingRequestCount === 0) {
    Toast.clear()
  }
}

axios.defaults.headers['Content-Type'] = 'application/json;charset=utf-8'

const errorCode = {
  401: '认证失败，无法访问系统资源',
  403: '当前操作没有权限',
  404: '访问资源不存在',
  default: '系统未知错误，请反馈给管理员'
}

// 创建axios实例
const service = axios.create({
  baseURL: "https://e.mtyee.cn/ruoyi-admin",
  timeout: 500000 // 超时
})

// request拦截器
service.interceptors.request.use(config => {
  if (!config.hideLoading) {
    showFullScreenLoading()
  }
  // 是否需要防止数据重复提交
  const isRepeatSubmit = (config.headers || {}).repeatSubmit === false
  // get请求映射params参数
  if (config.method === 'get' && config.params) {
    let url = config.url + '?' + tansParams(config.params)
    url = url.slice(0, -1)
    config.params = {}
    config.url = url
  }
  if (!isRepeatSubmit && (config.method === 'post' || config.method === 'put')) {
    const requestObj = {
      url: config.url,
      data: typeof config.data === 'object' ? JSON.stringify(config.data) : config.data,
      time: new Date().getTime()
    }
    const sessionObj = cache.session.getJSON('sessionObj')
    if (sessionObj === undefined || sessionObj === null || sessionObj === '') {
      cache.session.setJSON('sessionObj', requestObj)
    } else {
      const s_url = sessionObj.url // 请求地址
      const s_data = sessionObj.data // 请求数据
      const s_time = sessionObj.time // 请求时间
      const interval = 1000 // 间隔时间(ms)，小于此时间视为重复提交
      if (s_data === requestObj.data && requestObj.time - s_time < interval && s_url === requestObj.url) {
        const message = '数据正在处理，请勿重复提交'
        console.warn(`[${s_url}]: ` + message)
        return Promise.reject(new Error(message))
      } else {
        cache.session.setJSON('sessionObj', requestObj)
      }
    }
  }
  return config
}, error => {
  Promise.reject(error)
})

// 响应拦截器
service.interceptors.response.use(res => {
  if (!res.config.hideLoading) {
    tryHideFullScreenLoading()
  }
  // 未设置状态码则默认成功状态
  const code = res.data.code || 200
  // 获取错误信息
  const msg = errorCode[code] || res.data.msg || errorCode.default
  // 二进制数据则直接返回
  if (res.request.responseType === 'blob' || res.request.responseType === 'arraybuffer') {
    return res.data
  }

  if (code === 500) {
    if (!res.config.customError) {
      Toast({
        message: msg,
        type: 'fail'
      })
    }
    return Promise.reject(new Error(msg))
  } else if (code !== 200) {
    Notify({
      type: 'danger',
      message: msg
    })
    // eslint-disable-next-line prefer-promise-reject-errors
    return Promise.reject('error')
  } else {
    return Promise.resolve(res.data)
  }
}, error => {
  if (!error.config.hideLoading) {
    tryHideFullScreenLoading()
  }
  let { message } = error
  if (message === 'Network Error') {
    message = '后端接口连接异常'
  } else if (message.includes('timeout')) {
    message = '系统接口请求超时'
  } else if (message.includes('Request failed with status code')) {
    message = '系统接口' + message.substr(message.length - 3) + '异常'
  }
  Toast({
    message: message,
    type: 'fail',
    duration: 5 * 1000
  })
  return Promise.reject(error)
})

export default service
