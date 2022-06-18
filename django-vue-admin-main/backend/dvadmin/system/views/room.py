# -*- coding: utf-8 -*-

"""
@author: 猿小天
@contact: QQ:1638245306
@Created on: 2021/6/3 003 0:30
@Remark: 角色管理
"""
from rest_framework import serializers

from dvadmin.system.models import Room
from dvadmin.utils.json_response import SuccessResponse
from dvadmin.utils.serializers import CustomModelSerializer
from dvadmin.utils.viewset import CustomModelViewSet
from dvadmin.utils.face_identification import face_identify


class RoomSerializer(CustomModelSerializer):
    """
    教室-序列化器
    """
    parent_name = serializers.CharField(read_only=True,source='parent.name')
    class Meta:
        model = Room
        fields = "__all__"
        read_only_fields = ["id"]

class ExportUserProfileSerializer(CustomModelSerializer):
    """
    教室导出 序列化器
    """

    class Meta:
        model = Room
        fields = ('name', 'large', 'avatar', 'number')

class RoomProfileImportSerializer(CustomModelSerializer):
    """
    教室导入 序列化器
    """

    def save(self, **kwargs):
        data = super().save(**kwargs)
        data.set_number_uses()
        data.set_dept()
        data.save()
        return data

    class Meta:
        model = Room
        exclude = ('name', 'large', 'avatar', 'number')

class RoomCreateSerializer(CustomModelSerializer):
    """
    教室管理 创建时的列化器
    """

    def create(self, validated_data):
        instance = super().create(validated_data)
        instance.room_belong_id = instance.id
        instance.set_number_uses()
        instance.set_dept()
        instance.save()
        return instance

    class Meta:
        model = Room
        fields = '__all__'

class RoomUpdateSerializer(CustomModelSerializer):
    """
    教室管理 更新时的列化器
    """

    def save(self, **kwargs):
        data = super().save(**kwargs)
        data.set_number_uses()
        data.set_dept()
        data.save()
        return data

    class Meta:
        model = Room
        read_only_fields = ["id"]
        fields = '__all__'
        
class RoomViewSet(CustomModelViewSet):
    """
    教室管理接口
    list:查询
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = Room.objects.all()
    serializer_class = RoomSerializer
    create_serializer_class = RoomCreateSerializer
    update_serializer_class = RoomUpdateSerializer
    # 导出
    export_field_label = ['教室名称', '教室容量', '出勤照片', '出勤人数']
    export_serializer_class = ExportUserProfileSerializer
    #导入
    import_serializer_class = RoomProfileImportSerializer
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
