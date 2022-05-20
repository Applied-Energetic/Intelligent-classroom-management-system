# -*- coding: utf-8 -*-

"""
@author: 尚善蒲
@Remark: 教室预定
"""
from dvadmin.system.models import cBook
from dvadmin.utils.serializers import CustomModelSerializer
from dvadmin.utils.viewset import CustomModelViewSet


class cBookSerializer(CustomModelSerializer):
    """
    预订-序列化器
    """

    class Meta:
        model = cBook
        fields = "__all__"
        read_only_fields = ["id"]


class cBookViewSet(CustomModelViewSet):
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
