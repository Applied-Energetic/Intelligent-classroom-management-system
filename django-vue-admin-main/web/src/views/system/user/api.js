/*
 * @Auther: 夏妍
 * @文件介绍: 用户接口
 */
import { request, downloadFile } from '@/api/service'

export const urlPrefix = '/api/system/user/'

/**
 * 导出
 * @param params
 */
export function exportData (params) {
  return downloadFile({
    url: urlPrefix + 'export/',
    method: 'post',
    params: params
  })
}

export function GetList (query) {
  return request({
    url: urlPrefix,
    method: 'get',
    params: query
  })
}

export function AddObj (obj) {
  return request({
    url: urlPrefix,
    method: 'post',
    data: obj
  })
}

export function UpdateObj (obj) {
  return request({
    url: urlPrefix + obj.id + '/',
    method: 'put',
    data: obj
  })
}

export function DelObj (id) {
  return request({
    url: urlPrefix + id + '/',
    method: 'delete',
    data: { id }
  })
}

/**
 * 重置密码
 * @param id
 * @returns {*}
 * @constructor
 */
export function ResetPwd (obj) {
  return request({
    url: urlPrefix + 'reset_password/' + obj.id + '/',
    method: 'put',
    data: obj
  })
}
