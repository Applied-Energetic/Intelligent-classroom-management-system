// import { request } from '@/api/service'
// import { urlPrefix as messagePrefix } from './api'
// import XEUtils from 'xe-utils'
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
        title: '课程名',
        key: 'name',
        search: {
          disabled: false
        },
        type: 'input',
        form: {
          rules: [ // 表单校验规则
            { required: true, message: '课程名为必填项' }
          ],
          component: {
            span: 12,
            placeholder: '请输入课程名'
          },
          itemProps: {
            class: { yxtInput: true }
          }
        }
      },
      {
        title: '上课班级',
        key: 'cclass',
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
        title: '上课次数',
        key: 'num',
        sortable: true,
        form: {
          component: {
            span: 12,
            props: {
              clearable: true
            }
          }
        }
      }
    ].concat(vm.commonEndColumns({ update_datetime: { showForm: false, showTable: false }, create_datetime: { showForm: false, showTable: true } }))
  }
}
