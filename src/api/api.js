import request from '@/utils/request'

const BASE_URL = '/api'

export function openChat(data) {
  return request({
    url: '/utils/openChat',
    method: 'post',
    data: data
  })
}

export function aiChat(data) {
  return request({
    url: `${BASE_URL}/ai/chat`,
    method: 'post',
    data: data
  })
}

export function aiChatAsync(data) {
  return request({
    url: `${BASE_URL}/ai/chat/async`,
    method: 'post',
    data: data
  })
}

export function aiChatStream(data) {
  return request({
    url: `${BASE_URL}/ai/chat/stream`,
    method: 'post',
    data: data
  })
}

export function register(data) {
  return request({
    url: `${BASE_URL}/auth/register`,
    method: 'post',
    data: data
  })
}

export function login(data) {
  return request({
    url: `${BASE_URL}/auth/login`,
    method: 'post',
    data: data
  })
}

export function getUserById(id) {
  return request({
    url: `${BASE_URL}/users/${id}`,
    method: 'get'
  })
}

export function updateUser(id, data) {
  return request({
    url: `${BASE_URL}/users/${id}`,
    method: 'put',
    params: data
  })
}

export function verifyPhone(id) {
  return request({
    url: `${BASE_URL}/users/${id}/verify-phone`,
    method: 'post'
  })
}

export function verifyEmail(id) {
  return request({
    url: `${BASE_URL}/users/${id}/verify-email`,
    method: 'post'
  })
}

export function createSession(userId, model) {
  return request({
    url: `${BASE_URL}/chat/sessions`,
    method: 'post',
    params: { userId, model }
  })
}

export function getUserSessions(userId) {
  return request({
    url: `${BASE_URL}/chat/sessions/${userId}`,
    method: 'get'
  })
}

export function updateSessionTitle(sessionId, title) {
  return request({
    url: `${BASE_URL}/chat/sessions/${sessionId}/title`,
    method: 'put',
    params: { title }
  })
}

export function deleteSession(sessionId) {
  return request({
    url: `${BASE_URL}/chat/sessions/${sessionId}`,
    method: 'delete'
  })
}

export function getSessionMessages(sessionId) {
  return request({
    url: `${BASE_URL}/chat/sessions/${sessionId}/messages`,
    method: 'get'
  })
}
