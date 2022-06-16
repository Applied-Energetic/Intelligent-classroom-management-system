# -*- coding: utf-8 -*-

"""
@author: 陈佳婧
@Remark: 信息管理（排课）
"""
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated
from rest_framework import serializers

from dvadmin.system.models import Message
from dvadmin.system.views.file_list import FileSerializer
from dvadmin.utils.serializers import CustomModelSerializer
from dvadmin.utils.viewset import CustomModelViewSet
from dvadmin.utils.schedule import scheduling

class MessageSerializer(CustomModelSerializer):
    """
    信息-序列化器
    """

    class Meta:
        model = Message
        fields = "__all__"
        read_only_fields = ["id"]

class MessageCreateSerializer(CustomModelSerializer):
    """
    信息新增-序列化器
    """

    def save(self, **kwargs):
        data = super().save(**kwargs)
        data.set()
        data.save()
        scheduling(data.name, data.cclass, data.teacher, data.num)
        return data

    class Meta:
        model = Message
        fields = "__all__"
        read_only_fields = ["id"]
        extra_kwargs = {
            'post': {'required': False},
        }

class MessageUpdateSerializer(CustomModelSerializer):
    """
    选课管理 更新时的列化器
    """
    def save(self, **kwargs):
        data = super().save(**kwargs)
        data.set()
        data.save()
        return data

    class Meta:
        model = Message
        fields = '__all__'

class ExportMessageProfileSerializer(CustomModelSerializer):
    """
    选课导出 序列化器
    """

    class Meta:
        model = Message
        fields = ('name', 'cclass', 'teacher', 'num')

class MessageProfileImportSerializer(CustomModelSerializer):
    """
    选课导入 序列化器
    """

    def save(self, **kwargs):
        data = super().save(**kwargs)
        data.save()
        return data

    class Meta:
        model = Message

class MessageViewSet(CustomModelViewSet):
    """
    选课管理接口
    list:查询
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = Message.objects.all()
    serializer_class = MessageSerializer
    create_serializer_class = MessageCreateSerializer
    update_serializer_class = MessageUpdateSerializer
    extra_filter_backends = []
    # 导出
    export_field_label = ['课程名称', '上课班级', '任课老师', '上课次数']
    export_serializer_class = ExportMessageProfileSerializer
    #导入
    import_serializer_class = MessageProfileImportSerializer
    import_field_dict = {'name':'课程名称', 'cclass':'上课班级', 'teacher':'任课老师', 'num':'上课次数'}