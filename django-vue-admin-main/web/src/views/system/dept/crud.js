import { request } from '@/api/service'
import { BUTTON_STATUS_BOOL } from '@/config/button'
import { urlPrefix as deptPrefix } from './api'
import XEUtils from 'xe-utils'
import util from '@/libs/util'
const uploadUrl = util.baseURL() + 'api/system/file/'
export const crudOptions = (vm) => {
  return {
    pagination: false,
    pageOptions: {
      compact: true
    },
    options: {
      // tableType: 'vxe-table',
      // rowKey: true, // 必须设置，true or false
      rowId: 'id',
      height: '100%', // 表格高度100%, 使用toolbar必须设置
      highlightCurrentRow: false,
      defaultExpandAll: true
      // treeConfig: { // 树形数据配置
      //   expandAll: true,
      //   children: 'children',
      // }
    },
    rowHandle: {
      width: 140,
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
    indexRow: { // 或者直接传true,不显示title，不居中
      title: '序号',
      align: 'center',
      width: 100
    },

    viewOptions: {
      componentType: 'form'
    },
    formOptions: {
      defaultSpan: 12 // 默认的表单 span
    },
    columns: [{
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
          props: {
            clearable: true
          },
          placeholder: '请输入关键词'
        }
      },
      view: { // 查看对话框组件的单独配置
        disabled: true
      }
    },
    {
      title: 'ID',
      key: 'id',
      show: false,
      disabled: true,
      width: 90,
      form: {
        disabled: true
      }
    },
    {
      title: '教室位置',
      key: 'parent',
      show: false,
      search: {
        disabled: true
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
              showAllLevels: false, // 仅显示最后一级
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
      title: '教室名称',
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
        rules: [ // 表单校验规则
          { required: true, message: '教学楼名称必填项' }
        ],
        component: {
          span: 12,
          props: {
            clearable: true
          },
          placeholder: '请输入教室名称'
        },
        itemProps: {
          class: { yxtInput: true }
        }
      }
    },
    {
      title: '负责人',
      key: 'owner',
      sortable: true,
      form: {
        component: {
          span: 12,
          props: {
            clearable: true
          },
          placeholder: '请输入负责人'
        }
      }
    },
    {
      title: '联系电话',
      key: 'phone',
      sortable: true,
      form: {
        component: {
          span: 12,
          props: {
            clearable: true
          },
          placeholder: '请输入联系电话'
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
      title: '设备',
      key: 'tools',
      sortable: true,
      form: {
        component: {
          span: 12,
          props: {
            clearable: true
          },
          placeholder: '请输入设备基本信息'
        }
      }
    },
    {
      title: '容量',
      key: 'large',
      sortable: true,
      form: {
        component: {
          span: 12,
          props: {
            clearable: true
          },
          placeholder: '请输入教室容量'
        }
      }
    },
    {
      title: '使用须知',
      key: 'message',
      sortable: true,
      form: {
        component: {
          span: 12,
          props: {
            clearable: true
          },
          placeholder: '请输入该教室使用须知'
        }
      }
    },
    {
      title: '流量照片',
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
      title: '当前人数',
      key: 'number',
      dict: {
        cache: false,
        url: deptPrefix,
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
      title: '排序',
      key: 'sort',
      sortable: true,
      width: 80,
      type: 'number',
      form: {
        value: 1,
        component: {
          span: 12,
          placeholder: '请选择序号'
        }
      }
    },
    {
      title: '状态',
      key: 'status',
      sortable: true,
      search: {
        disabled: false
      },
      width: 90,
      type: 'radio',
      dict: {
        data: BUTTON_STATUS_BOOL
      },
      form: {
        value: true,
        component: {
          span: 12,
          placeholder: '请选择状态'
        }
      }
    },
    {
      title: '使用情况',
      key: 'uses',
      sortable: false,
      dict: {
        cache: false,
        url: deptPrefix,
        value: 'id',
        lable: 'uses',
        getData: (url, dict) => { // 配置此参数会覆盖全局的getRemoteDictFunc
          return request({ url: url }).then(ret => {
            const data = XEUtils(ret.data.data)
            return data
          })
        }
      },
      form: {
        disabled: true,
        component: {
          span: 12
        }
      }
    }
    ].concat(vm.commonEndColumns())
  }
}
