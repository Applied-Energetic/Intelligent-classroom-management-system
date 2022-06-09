import { request } from '@/api/service'
import { urlPrefix as messagePrefix } from '../message/api'
import { urlPrefix as schedulePrefix } from './api'
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
        title: '班级名称',
        key: 'cclass',
        show: true,
        search: {
          disabled: false
        },
        type: 'select',
        dict: {
          cache: false,
          url: messagePrefix + '?limit=999&status=1',
          isTree: true,
          value: 'id', // 数据字典中value字段的属性名
          label: 'cclass', // 数据字典中label字段的属性名
          getData: (url, dict) => { // 配置此参数会覆盖全局的getRemoteDictFunc
            return request({ url: url }).then(ret => {
              const data = XEUtils.toArrayTree(ret.data.data)
              return data
            })
          }
        },
        form: {
          component: {
            span: 12,
            props: {
              elProps: {
                clearable: true,
                props: {
                  clearable: true
                }
              }
            }
          }
        }
      },
      {
        title: '班级课表',
        key: 'image',
        dict: {
          cache: false,
          url: schedulePrefix,
          value: 'id',
          lable: 'image',
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
      }
    ].concat(vm.commonEndColumns({ update_datetime: { showForm: false, showTable: true }, create_datetime: { showForm: false, showTable: true } }))
  }
}
