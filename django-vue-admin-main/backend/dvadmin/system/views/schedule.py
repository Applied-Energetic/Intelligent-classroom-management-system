# -*- coding: utf-8 -*-

"""
@author: 陈佳婧
@Remark: 信息管理（排课）
"""
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated
from rest_framework import serializers

from dvadmin.system.models import Schedule
from dvadmin.system.views.file_list import FileSerializer
from dvadmin.utils.serializers import CustomModelSerializer
from dvadmin.utils.viewset import CustomModelViewSet

class ScheduleSerializer(CustomModelSerializer):
    """
    信息-序列化器
    """

    class Meta:
        model = Schedule
        fields = "__all__"
        read_only_fields = ["id"]

class ScheduleCreateSerializer(CustomModelSerializer):
    """
    信息新增-序列化器
    """

    def save(self, **kwargs):
        data = super().save(**kwargs)
        data.set()
        data.save()
        return data

    class Meta:
        model = Schedule
        fields = "__all__"
        read_only_fields = ["id"]
        extra_kwargs = {
            'post': {'required': False},
        }

class ScheduleUpdateSerializer(CustomModelSerializer):
    """
    选课管理 更新时的列化器
    """
    def save(self, **kwargs):
        data = super().save(**kwargs)
        data.set()
        data.save()
        return data

    class Meta:
        model = Schedule
        fields = '__all__'

class ExportScheduleProfileSerializer(CustomModelSerializer):
    """
    选课导出 序列化器
    """

    class Meta:
        model = Schedule
        fields = ('name', 'image')

class ScheduleProfileImportSerializer(CustomModelSerializer):
    """
    选课导入 序列化器
    """

    def save(self, **kwargs):
        data = super().save(**kwargs)
        data.save()
        return data

    class Meta:
        model = Schedule

class ScheduleViewSet(CustomModelViewSet):
    """
    选课管理接口
    list:查询
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = Schedule.objects.all()
    serializer_class = ScheduleSerializer
    create_serializer_class = ScheduleCreateSerializer
    update_serializer_class = ScheduleUpdateSerializer
    extra_filter_backends = []
    # 导出
    export_field_label = ['班级名称', '课表']
    export_serializer_class = ExportScheduleProfileSerializer
    #导入
    import_serializer_class = ScheduleProfileImportSerializer
    import_field_dict = {'name':'班级名称', 'image':'课表'}