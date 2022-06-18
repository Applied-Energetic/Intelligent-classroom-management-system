import { request } from '@/api/service'
import { urlPrefix as kechengPrefix } from './api'
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
        title: '上课班级',
        key: 'name',
        sortable: true,
        form: {
          component: {
            span: 12,
            props: {
              clearable: true
            }
          }
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
        title: '班级课表',
        key: 'image',
        type: 'image-uploader',
        dict: {
          cache: false,
          url: kechengPrefix,
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
