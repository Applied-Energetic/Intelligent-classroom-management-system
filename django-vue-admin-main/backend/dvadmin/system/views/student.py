# -*- coding: utf-8 -*-

"""
@Remark: 出勤管理
"""
from dvadmin.system.models import Student
from dvadmin.utils.serializers import CustomModelSerializer
from dvadmin.utils.viewset import CustomModelViewSet


class StudentSerializer(CustomModelSerializer):
    """
    出勤-序列化器
    """

    class Meta:
        model = Student
        fields = "__all__"
        read_only_fields = ["id"]


class StudentViewSet(CustomModelViewSet):
    """
    预订权限接口
    list:查询
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = Student.objects.all()
    serializer_class = StudentSerializer
    extra_filter_backends = []
