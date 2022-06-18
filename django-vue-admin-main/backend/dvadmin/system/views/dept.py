# -*- coding: utf-8 -*-

"""
@author: 陈佳婧
@Remark: 权限管理
"""
from rest_framework import serializers

from dvadmin.system.models import Dept
from dvadmin.utils.json_response import SuccessResponse
from dvadmin.utils.serializers import CustomModelSerializer
from dvadmin.utils.viewset import CustomModelViewSet
from dvadmin.utils.face_identification import face_identify


class DeptSerializer(CustomModelSerializer):
    """
    权限-序列化器
    """
    parent_name = serializers.CharField(read_only=True,source='parent.name')
    class Meta:
        model = Dept
        fields = "__all__"
        read_only_fields = ["id"]

class DeptCreateSerializer(CustomModelSerializer):
    """
    权限管理 创建时的列化器
    """

    def create(self, validated_data):
        instance = super().create(validated_data)
        instance.dept_belong_id = instance.id
        instance.save()
        return instance

    class Meta:
        model = Dept
        fields = '__all__'

class DeptUpdateSerializer(CustomModelSerializer):
    """
    权限管理 更新时的列化器
    """

    def save(self, **kwargs):
        data = super().save(**kwargs)
        data.save()
        return data

    class Meta:
        model = Dept
        read_only_fields = ["id"]
        fields = '__all__'
        
class DeptViewSet(CustomModelViewSet):
    """
    权限管理接口
    list:查询
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = Dept.objects.all()
    serializer_class = DeptSerializer
    create_serializer_class = DeptCreateSerializer
    update_serializer_class = DeptUpdateSerializer

    # extra_filter_backends = []

    # def list(self, request, *args, **kwargs):
    #     queryset = self.filter_queryset(self.get_queryset())
    #     page = self.paginate_queryset(queryset)
    #     if page is not None:
    #         serializer = self.get_serializer(page, many=True, request=request)
    #         return self.get_paginated_response(serializer.data)
    #     serializer = self.get_serializer(queryset, many=True, request=request)
    #     return SuccessResponse(data=serializer.data, msg="获取成功")
