# -*- coding: utf-8 -*-

"""
@author: 陈佳婧
@Remark: 预订管理
"""
#预定管理用于审批学生以及老师的审批，因此和cbook文件共用同一个数据库
from dvadmin.system.models import Book
from dvadmin.system.models import cBook
from dvadmin.utils.serializers import CustomModelSerializer
from dvadmin.utils.viewset import CustomModelViewSet
from dvadmin.system.views.cbook import cBookSerializer


class BookViewSet(CustomModelViewSet):
    """
    预订权限接口
    list:查询
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = cBook.objects.all()
    serializer_class = cBookSerializer
    extra_filter_backends = []
