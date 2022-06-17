# -*- coding: utf-8 -*-

"""
@author: 陈佳婧
@Remark: 信息管理（排课）
"""
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated
from rest_framework import serializers

from dvadmin.system.models import Kecheng
from dvadmin.system.views.file_list import FileSerializer
from dvadmin.utils.serializers import CustomModelSerializer
from dvadmin.utils.viewset import CustomModelViewSet

class KechengSerializer(CustomModelSerializer):
    """
    信息-序列化器
    """

    class Meta:
        model = Kecheng
        fields = "__all__"
        read_only_fields = ["id"]

class KechengCreateSerializer(CustomModelSerializer):
    """
    信息新增-序列化器
    """

    def save(self, **kwargs):
        data = super().save(**kwargs)
        data.set()
        data.save()
        return data

    class Meta:
        model = Kecheng
        fields = "__all__"
        read_only_fields = ["id"]
        extra_kwargs = {
            'post': {'required': False},
        }

class KechengUpdateSerializer(CustomModelSerializer):
    """
    课表管理 更新时的列化器
    """
    def save(self, **kwargs):
        data = super().save(**kwargs)
        data.set()
        data.save()
        return data

    class Meta:
        model = Kecheng
        fields = '__all__'

class ExportKechengProfileSerializer(CustomModelSerializer):
    """
    课表导出 序列化器
    """

    class Meta:
        model = Kecheng
        fields = ('name', 'image')

class KechengProfileImportSerializer(CustomModelSerializer):
    """
    课表导入 序列化器
    """

    def save(self, **kwargs):
        data = super().save(**kwargs)
        data.set()
        data.save()
        return data

    class Meta:
        model = Kecheng

class KechengViewSet(CustomModelViewSet):
    """
    课表管理接口
    list:查询
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = Kecheng.objects.all()
    serializer_class = KechengSerializer
    create_serializer_class = KechengCreateSerializer
    update_serializer_class = KechengUpdateSerializer
    extra_filter_backends = []
    # 导出
    export_field_label = ['班级名称', '课表']
    export_serializer_class = ExportKechengProfileSerializer
    #导入
    import_serializer_class = KechengProfileImportSerializer
    import_field_dict = {'name':'班级名称', 'image':'课表'}