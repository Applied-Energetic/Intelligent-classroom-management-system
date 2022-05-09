# -*- coding: utf-8 -*-

"""
@author: 陈佳婧
@Remark: 出勤管理
"""
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated

from dvadmin.system.models import Student
from dvadmin.system.views.file_list import FileSerializer
from dvadmin.utils.serializers import CustomModelSerializer
from dvadmin.utils.viewset import CustomModelViewSet
from dvadmin.utils.face_identification import face_identify
from dvadmin.utils.json_response import DetailResponse


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

    @action(methods=['POST'], detail=True, permission_classes=[IsAuthenticated])
    def identify(self, request):
        """人脸识别"""
        student = request.student
        image_url = student.avatar
        facenum = face_identify(image_url)
        Student.objects.filter(id=student.id).update(number=facenum)
        return DetailResponse(data=None, msg="识别成功")