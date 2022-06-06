import { request } from '@/api/service'
import { urlPrefix as schedulePrefix } from '../schedule/api'
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
        title: '课程类型',
        key: 'opinion',
        search: {
          disabled: true
        },
        width: 70,
        type: 'select',
        dict: {
          data: [
            { value: '0', label: '通识课' },
            { value: '1', label: '专业课（计）' },
            { value: '2', label: '专业课（经）' },
            { value: '3', label: '公选课' }
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
        title: '上课时间',
        key: 'classtime',
        sortable: true,
        width: 180,
        search: {
          disabled: false,
          title: '上课时间'
        },
        type: 'select',
        form: {
          title: '上课时间',
          component: {
            props: {
              filterable: true,
              multiple: true,
              clearable: true
            }
          }
        },
        dict: {
          data: [
            { value: '0', label: '周一第一节' },
            { value: '1', label: '周一第二节' },
            { value: '2', label: '周一第三节' },
            { value: '3', label: '周一第四节' },
            { value: '4', label: '周一第五节' },
            { value: '5', label: '周一第六节' },
            { value: '6', label: '周二第一节' },
            { value: '7', label: '周二第二节' },
            { value: '8', label: '周二第三节' },
            { value: '9', label: '周二第四节' },
            { value: '10', label: '周二第五节' },
            { value: '11', label: '周二第六节' },
            { value: '12', label: '周三第一节' },
            { value: '13', label: '周三第二节' },
            { value: '14', label: '周三第三节' },
            { value: '15', label: '周三第四节' },
            { value: '16', label: '周三第五节' },
            { value: '17', label: '周三第六节' },
            { value: '18', label: '周四第一节' },
            { value: '19', label: '周四第二节' },
            { value: '20', label: '周四第三节' },
            { value: '21', label: '周四第四节' },
            { value: '22', label: '周四第五节' },
            { value: '23', label: '周四第六节' },
            { value: '24', label: '周五第一节' },
            { value: '25', label: '周五第二节' },
            { value: '26', label: '周五第三节' },
            { value: '27', label: '周五第四节' },
            { value: '28', label: '周五第五节' },
            { value: '29', label: '周五第六节' }
          ]
        },
        component: { props: { color: 'auto' } } // 自动染色
      },
      {
        title: '教室位置',
        key: 'place',
        dict: {
          cache: false,
          url: schedulePrefix,
          value: 'id',
          lable: 'place',
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
    ].concat(vm.commonEndColumns({ update_datetime: { showForm: false, showTable: false }, create_datetime: { showForm: false, showTable: true } }))
  }
}
