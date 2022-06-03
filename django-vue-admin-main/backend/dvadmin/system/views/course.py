# -*- coding: utf-8 -*-

"""
@author: 陈佳婧
@Remark: 选课管理
"""
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated
from rest_framework import serializers

from dvadmin.system.models import Course
from dvadmin.system.views.file_list import FileSerializer
from dvadmin.utils.serializers import CustomModelSerializer
from dvadmin.utils.viewset import CustomModelViewSet
from dvadmin.utils.face_identification import face_identify

class CourseSerializer(CustomModelSerializer):
    """
    选课-序列化器
    """

    class Meta:
        model = Course
        fields = "__all__"
        read_only_fields = ["id"]

class CourseCreateSerializer(CustomModelSerializer):
    """
    选课新增-序列化器
    """

    def save(self, **kwargs):
        data = super().save(**kwargs)
        data.regist()
        data.save()
        return data

    class Meta:
        model = Course
        fields = "__all__"
        read_only_fields = ["id"]
        extra_kwargs = {
            'post': {'required': False},
        }

class UpdateSerializer(CustomModelSerializer):
    """
    选课管理 更新时的列化器
    """
    def save(self, **kwargs):
        data = super().save(**kwargs)
        data.regist()
        data.save()
        return data

    class Meta:
        model = Course
        fields = '__all__'

class ExportCourseProfileSerializer(CustomModelSerializer):
    """
    选课导出 序列化器
    """

    class Meta:
        model = Course
        fields = ('name', 'avatar', 'email', 'cname')

class CourseProfileImportSerializer(CustomModelSerializer):
    """
    选课导入 序列化器
    """

    def save(self, **kwargs):
        data = super().save(**kwargs)
        data.save()
        return data

    class Meta:
        model = Course

class CourseViewSet(CustomModelViewSet):
    """
    选课管理接口
    list:查询
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = Course.objects.all()
    serializer_class = CourseSerializer
    create_serializer_class = CourseCreateSerializer
    update_serializer_class = CourseUpdateSerializer
    extra_filter_backends = []
    # 导出
    export_field_label = ['姓名', '学生照片', '邮箱', '课程名称']
    export_serializer_class = ExportCourseProfileSerializer
    #导入
    import_serializer_class = CourseProfileImportSerializer
    import_field_dict = {'name':'姓名', 'avatar':'学生照片', 'email':'邮箱', 'cname':'课程名称'}