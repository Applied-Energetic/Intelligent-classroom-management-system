# -*- coding: utf-8 -*-

"""
@author: 猿小天
@contact: QQ:1638245306
@Created on: 2021/6/3 003 0:30
@Remark: 角色管理
"""
from rest_framework import serializers

from dvadmin.system.models import Dept
from dvadmin.utils.json_response import SuccessResponse
from dvadmin.utils.serializers import CustomModelSerializer
from dvadmin.utils.viewset import CustomModelViewSet
from dvadmin.utils.face_identification import face_identify


class DeptSerializer(CustomModelSerializer):
    """
    教室-序列化器
    """
    parent_name = serializers.CharField(read_only=True,source='parent.name')
    class Meta:
        model = Dept
        fields = "__all__"
        read_only_fields = ["id"]

class ExportUserProfileSerializer(CustomModelSerializer):
    """
    教室导出 序列化器
    """

    class Meta:
        model = Dept
        fields = ('name', 'large', 'avatar', 'number')

class DeptProfileImportSerializer(CustomModelSerializer):
    """
    教室导入 序列化器
    """

    def save(self, **kwargs):
        data = super().save(**kwargs)
        data.save()
        return data

    class Meta:
        model = Dept
        exclude = ('name', 'large', 'avatar', 'number')

class DeptCreateSerializer(CustomModelSerializer):
    """
    教室管理 创建/更新时的列化器
    """

    def create(self, validated_data):
        instance = super().create(validated_data)
        instance.dept_belong_id = instance.id
        number = face_identify(str(instance.avatar))
        instance.set_number(number)
        instance.save()
        return instance

    class Meta:
        model = Dept
        fields = '__all__'

class DeptUpdateSerializer(CustomModelSerializer):
    """
    部门管理 更新时的列化器
    """

    def save(self, **kwargs):
        data = super().save(**kwargs)
        data.avatar.set(self.initial_data.get('avatar', []))
        number = face_identify(str(self.initial_data.get('avatar','')))
        data.set_number(number)
        data.save()
        return data

    class Meta:
        model = Dept
        read_only_fields = ["id"]
        fields = '__all__'
        
class DeptViewSet(CustomModelViewSet):
    """
    部门管理接口
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
    # 导出
    export_field_label = ['教室名称', '教室容量', '出勤照片', '出勤人数']
    export_serializer_class = ExportUserProfileSerializer
    #导入
    import_serializer_class = DeptProfileImportSerializer
    import_field_dict = {'name':'教室名称', 'large':'教室容量', 'avatar':'出勤照片', 'number':'出勤人数'}

    # extra_filter_backends = []

    # def list(self, request, *args, **kwargs):
    #     queryset = self.filter_queryset(self.get_queryset())
    #     page = self.paginate_queryset(queryset)
    #     if page is not None:
    #         serializer = self.get_serializer(page, many=True, request=request)
    #         return self.get_paginated_response(serializer.data)
    #     serializer = self.get_serializer(queryset, many=True, request=request)
    #     return SuccessResponse(data=serializer.data, msg="获取成功")
