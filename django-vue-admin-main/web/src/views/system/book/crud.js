import { request } from '@/api/service'
import { BUTTON_CBOOK_BOOL } from '@/config/button'
import { urlPrefix as deptPrefix } from '../dept/api'
import XEUtils from 'xe-utils'
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
        title: '审批',
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
        key: 'parent',
        show: true,
        search: {
          disabled: false
        },
        type: 'cascader',
        dict: {
          cache: false,
          url: deptPrefix + '?limit=999&status=1',
          isTree: true,
          value: 'id', // 数据字典中value字段的属性名
          label: 'name', // 数据字典中label字段的属性名
          children: 'children', // 数据字典中children字段的属性名
          getData: (url, dict) => { // 配置此参数会覆盖全局的getRemoteDictFunc
            return request({ url: url }).then(ret => {
              const data = XEUtils.toArrayTree(ret.data.data, { parentKey: 'parent', strict: true })
              return [{ id: '0', name: '根节点', children: data }]
            })
          }
        },
        form: {
          component: {
            span: 12,
            props: {
              elProps: {
                clearable: true,
                showAllLevels: true,
                props: {
                  checkStrictly: true, // 可以不需要选到最后一级
                  emitPath: false,
                  clearable: true
                }
              }
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
          data: BUTTON_CBOOK_BOOL
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
        search: {
          disabled: true
        },
        width: 70,
        type: 'select',
        dict: {
          data: [
            { value: '0', label: '待审批' },
            { value: '1', label: '同意' },
            { value: '2', label: '拒绝' }
          ]
        },
        form: {
          value: true,
          component: {
            span: 12
          }
        }
      },
      {
        title: '预约时间',
        key: 'begin_date',
        sortable: true,
        type: 'datetime',
        form: {
          component: {
            span: 24,
            props: {
              clearable: true,
              format: 'yyyy-MM-dd HH:mm:ss',
              valueFormat: 'yyyy-MM-dd HH:mm:ss'
            },
            placeholder: '请输入预约时间'
          },
          itemProps: {
            class: { yxtInput: true }
          }
        }
      },
      {
        title: '结束时间',
        key: 'end_time',
        sortable: true,
        type: 'datetime',
        form: {
          component: {
            span: 24,
            props: {
              clearable: true,
              format: 'yyyy-MM-dd HH:mm:ss',
              valueFormat: 'yyyy-MM-dd HH:mm:ss'
            },
            placeholder: '请输入结束时间'
          },
          itemProps: {
            class: { yxtInput: true }
          }
        }
      }
    ].concat(vm.commonEndColumns({ update_datetime: { showForm: false, showTable: false }, create_datetime: { showForm: false, showTable: true } }))
  }
}
