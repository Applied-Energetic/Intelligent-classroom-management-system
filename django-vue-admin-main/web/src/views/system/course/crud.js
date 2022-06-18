import { request } from '@/api/service'
// import { BUTTON_STATUS_BOOL } from '@/config/button'
import util from '@/libs/util'
// import XEUtils from 'xe-utils'
import { urlPrefix as deptPrefix } from '../dept/api'
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
        title: '姓名',
        key: 'name',
        search: {
          disabled: false
        },
        type: 'input',
        form: {
          rules: [ // 表单校验规则
            { required: true, message: '姓名必填项' }
          ],
          component: {
            span: 12,
            placeholder: '请输入姓名'
          },
          itemProps: {
            class: { yxtInput: true }
          }
        }
      },
      {
        title: '学生照片',
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
          helper: '请上传学生图片'
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
        title: '邮箱',
        key: 'email',
        sortable: true,
        form: {
          component: {
            span: 12,
            props: {
              clearable: true
            },
            placeholder: '请输入邮箱'
          },
          rules: [
            { type: 'email', message: '请输入正确的邮箱地址', trigger: ['blur', 'change'] }
          ]
        }
      },
      {
        title: '课程名称',
        key: 'cname',
        search: {
          disabled: false
        },
        type: 'input',
        form: {
          rules: [ // 表单校验规则
            { required: true, message: '课程必填项' }
          ],
          component: {
            span: 12,
            placeholder: '请输入课程名称'
          },
          itemProps: {
            class: { yxtInput: true }
          }
        }
      },
      {
        title: '权限',
        key: 'dept',
        search: {
          disabled: true
        },
        minWidth: 140,
        type: 'table-selector',
        dict: {
          cache: false,
          url: deptPrefix,
          value: 'id', // 数据字典中value字段的属性名
          label: 'name', // 数据字典中label字段的属性名
          getData: (url, dict, { form, component }) => {
            return request({ url: url, params: { page: 1, limit: 10, status: 1 } }).then(ret => {
              component._elProps.page = ret.data.page
              component._elProps.limit = ret.data.limit
              component._elProps.total = ret.data.total
              return ret.data.data
            })
          }
        },
        disabled: true,
        form: {
          rules: [ // 表单校验规则
            { required: true, message: '必填项' }
          ],
          itemProps: {
            class: { yxtInput: true }
          },
          disabled: true,
          component: {
            span: 12,
            props: { multiple: false },
            elProps: {
              pagination: true,
              columns: [
                {
                  field: 'name',
                  title: '权限名称'
                },
                {
                  field: 'status_label',
                  title: '状态'
                },
                {
                  field: 'parent_name',
                  title: '总权限'
                }
              ]
            }
          }
        }
      }
    ].concat(vm.commonEndColumns({ update_datetime: { showForm: false, showTable: true }, create_datetime: { showForm: false, showTable: true } }))
  }
}
