import { request } from '@/api/service'
import { BUTTON_cBOOK_BOOL,BUTTON_AUDIT_BOOL,BUTTON_ADMIN_BOOL } from '@/config/button'
import { urlPrefix as deptPrefix } from '../dept/api'
// import util from '@/libs/util'
// import { Avatar } from 'node_modules/element-ui/types/element-ui'

// const uploadUrl = util.baseURL() + 'api/system/file/'
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
      }
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
        key: 'booker',
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
        title: '教室位置',
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
        form: {
          itemProps: {
            class: { yxtInput: true }
          },
          component: {
            span: 12,
            props: { multiple: false },
            elProps: {
              pagination: true,
              columns: [
                {
                  field: 'name',
                  title: '教室名称'
                },
                {
                  field: 'status_label',
                  title: '状态'
                },
                {
                  field: 'parent_name',
                  title: '教室位置'
                }
              ]
            }
          }
        }
      },
      {
        title: '手机号码',
        key: 'mobile',
        search: {
          disabled: true
        },
        minWidth: 110,
        type: 'input',
        form: {
          rules: [
            { max: 20, message: '请输入正确的手机号码', trigger: 'blur' },
            { pattern: /^1[3|4|5|7|8]\d{9}$/, message: '请输入正确的手机号码' }
          ],
          itemProps: {
            class: { yxtInput: true }
          },
          component: {
            placeholder: '请输入手机号码'
          }
        }
      },
      {
        title: '邮箱',
        key: 'email',
        minWidth: 160,
        form: {
          rules: [
            { type: 'email', message: '请输入正确的邮箱地址', trigger: ['blur', 'change'] }
          ],
          component: {
            placeholder: '请输入邮箱'
          }
        }
      },
      {
        title: '状态',
        key: 'need',
        search: {
          disabled: false
        },
        width: 70,
        type: 'radio',
        dict: {
          data: BUTTON_AUDIT_BOOL
        },
        form: {
          value: true,
          component: {
            span: 12
          }
        }
      },
      {
        title: '申请理由',
        key: 'reason',
        sortable: true,
        form: {
          component: {
            span: 12,
            props: {
              clearable: true
            },
            placeholder: '请输入申请理由'
          }
        }
      },
      {
        title: '管理员审批',
        key: 'opinion',
        width: 70,
        type: 'radio',
        dict: {
          data: BUTTON_ADMIN_BOOL
        },
        // form: {
        //   disabled: true,
        //   value: true,
        //   component: {
        //     span: 12
        //   }
        // }
        // form: {
        //   rules: [ // 表单校验规则
        //     { required: false, message: '' }
        //   ],
        //   component: {
        //     span: 12,
        //     placeholder: '请输入姓名'
        //   },
        //   itemProps: {
        //     class: { yxtInput: true }
        //   }
        // }
        form: {
          value: true,
          component: {
            span: 12
          }
        }
      }
    ].concat(vm.commonEndColumns({ update_datetime: { showForm: false, showTable: false }, create_datetime: { showForm: false, showTable: true } }))
  }
}
