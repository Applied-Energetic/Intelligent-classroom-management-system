import { request } from '@/api/service'
// import { BUTTON_STATUS_BOOL } from '@/config/button'
import util from '@/libs/util'
import { urlPrefix as studentPrefix } from './api'
import XEUtils from 'xe-utils'
const uploadUrl = util.baseURL() + 'api/system/file/'
export const crudOptions = (vm) => {
  return {
    pageOptions: {
      compact: true
    },
    options: {
      height: '100%'
    },
    rowHandle: {
      fixed: 'right',
      width: 180,
      view: {
        thin: true,
        text: '',
        disabled () {
          return !vm.hasPermissions('Retrieve')
        }
      },
      edit: {
        thin: true,
        text: '',
        disabled () {
          return !vm.hasPermissions('Update')
        }
      },
      remove: {
        thin: true,
        text: '',
        disabled () {
          return !vm.hasPermissions('Delete')
        }
      },
      custom: [
        {
          thin: true,
          text: '',
          size: 'small',
          type: 'warning',
          icon: 'el-icon-refresh-left',
          show () {
            return vm.hasPermissions('ResetPwd')
          },
          emit: 'resetPwd'
        }
      ]

    },
    viewOptions: {
      componentType: 'form'
    },
    formOptions: {
      defaultSpan: 12 // 默认的表单 span
    },
    indexRow: { // 或者直接传true,不显示title，不居中
      title: '序号',
      align: 'center',
      width: 70
    },
    columns: [
      {
        title: '关键词',
        key: 'search',
        show: false,
        disabled: true,
        search: {
          disabled: false
        },
        form: {
          disabled: true,
          component: {
            placeholder: '请输入关键词'
          }
        },
        view: {
          disabled: true
        }
      },
      {
        title: 'ID',
        key: 'id',
        width: 90,
        disabled: true,
        form: {
          disabled: true
        }
      },
      {
        title: '出勤照片',
        key: 'avatar',
        type: 'avatar-uploader',
        width: 100,
        align: 'left',
        form: {
          component: {
            props: {
              uploader: {
                action: uploadUrl,
                headers: {
                  Authorization: 'JWT ' + util.cookies.get('token')
                },
                type: 'form',
                successHandle (ret, option) {
                  if (ret.data === null || ret.data === '') {
                    throw new Error('上传失败')
                  }
                  return { url: util.baseURL() + ret.data.url, key: option.data.key }
                }
              },
              elProps: { // 与el-uploader 配置一致
                multiple: true,
                limit: 5 // 限制5个文件
              },
              sizeLimit: 1024 * 1024 * 1024 * 1024 * 1024 // 不能超过限制
            },
            span: 24
          },
          helper: '请上传考勤图片'
        },
        valueResolve (row, col) {
          const value = row[col.key]
          if (value != null && value instanceof Array) {
            if (value.length >= 0) {
              row[col.key] = value[0]
            } else {
              row[col.key] = null
            }
          }
        },
        component: {
          props: {
            buildUrl (value, item) {
              if (value && value.indexOf('http') !== 0) {
                return util.baseURL() + value
              }
              return value
            }
          }
        }
      },
      {
        title: '出勤人数',
        key: 'number',
        dict: {
          cache: false,
          url: studentPrefix,
          value: 'id',
          lable: 'number',
          getData: (url, dict) => { // 配置此参数会覆盖全局的getRemoteDictFunc
            return request({ url: url }).then(ret => {
              const data = XEUtils(ret.data.data)
              return data
            })
          }
        },
        form: {
          disabled: true,
          value: true,
          component: {
            span: 12
          }
        }
      },
      {
        title: '课程名称',
        key: 'name',
        sortable: true,
        treeNode: true, // 设置为树形列
        search: {
          disabled: false,
          component: {
            props: {
              clearable: true
            }
          }
        },
        width: 180,
        type: 'input',
        form: {
          component: {
            span: 12,
            props: {
              clearable: true
            },
            placeholder: '请输入课程名称'
          },
          itemProps: {
            class: { yxtInput: true }
          }
        }
      }
    ].concat(vm.commonEndColumns({ update_datetime: { showForm: false, showTable: false }, create_datetime: { showForm: false, showTable: true } }))
  }
}
