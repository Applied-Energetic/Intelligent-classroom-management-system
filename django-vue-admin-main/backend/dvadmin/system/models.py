from __future__ import nested_scopes
import hashlib
import os
from urllib.parse import uses_fragment
from zipfile import LargeZipFile
import numpy as np

from django.contrib.auth.models import AbstractUser
from django.db import models
from django.forms import NullBooleanField
from django.conf import settings

from dvadmin.utils.models import CoreModel, table_prefix
from dvadmin.utils.face_identification import face_identify
from dvadmin.utils.face_identification2 import pic
from dvadmin.utils.face_identification2 import registeredIdentity
from dvadmin.utils.mail import send_email_demo

STATUS_CHOICES = (
    (0, "禁用"),
    (1, "启用"),
)
# 其他status同样可以控制启用与否
# sort可以决定排序


class Users(AbstractUser, CoreModel):
    username = models.CharField(max_length=150, unique=True, db_index=True, verbose_name='用户账号', help_text="用户账号")
    email = models.EmailField(max_length=255, verbose_name="邮箱", null=True, blank=True, help_text="邮箱")
    mobile = models.CharField(max_length=255, verbose_name="电话", null=True, blank=True, help_text="电话")
    avatar = models.CharField(max_length=255, verbose_name="头像", null=True, blank=True, help_text="头像")
    name = models.CharField(max_length=40, verbose_name="姓名", help_text="姓名")
    GENDER_CHOICES = (
        (0, "女"),
        (1, "男"),
    )
    gender = models.IntegerField(choices=GENDER_CHOICES, default=1, verbose_name="性别", null=True, blank=True,
                                 help_text="性别")
    USER_TYPE = (
        (0, "后台用户"),
        (1, "前台用户"),
    )
    user_type = models.IntegerField(choices=USER_TYPE, default=0, verbose_name="用户类型", null=True, blank=True,
                                    help_text="用户类型")
    post = models.ManyToManyField(to='Post', verbose_name='关联岗位', db_constraint=False, help_text="关联岗位")
    role = models.ManyToManyField(to='Role', verbose_name='关联角色', db_constraint=False, help_text="关联角色")
    is_active = models.BooleanField(default=True, verbose_name="用户状态", null=True, blank=True, help_text="用户状态")
    # 不需要对应教室
    dept = models.ForeignKey(to='Dept', verbose_name='所属部门', on_delete=models.PROTECT, db_constraint=False, null=True,
                              blank=True, help_text="关联权限")

    def set_password(self, raw_password):
        super().set_password(hashlib.md5(raw_password.encode(encoding='UTF-8')).hexdigest())

    class Meta:
        db_table = table_prefix + "system_users"
        verbose_name = '用户表'
        verbose_name_plural = verbose_name
        ordering = ('-create_datetime',)


class Post(CoreModel):
    name = models.CharField(null=False, max_length=64, verbose_name="岗位名称", help_text="岗位名称")
    code = models.CharField(max_length=32, verbose_name="岗位编码", help_text="岗位编码")
    sort = models.IntegerField(default=1, verbose_name="岗位顺序", help_text="岗位顺序")
    STATUS_CHOICES = (
        (0, "离职"),
        (1, "在职"),
    )
    status = models.IntegerField(choices=STATUS_CHOICES, default=1, verbose_name="岗位状态", help_text="岗位状态")

    class Meta:
        db_table = table_prefix + "system_post"
        verbose_name = '岗位表'
        verbose_name_plural = verbose_name
        ordering = ('sort',)


class Role(CoreModel):
    name = models.CharField(max_length=64, verbose_name="角色名称", help_text="角色名称")
    key = models.CharField(max_length=64, unique=True, verbose_name="权限字符", help_text="权限字符")
    sort = models.IntegerField(default=1, verbose_name="角色顺序", help_text="角色顺序")
    status = models.BooleanField(default=True, verbose_name="角色状态", help_text="角色状态")
    admin = models.BooleanField(default=False, verbose_name="是否为admin", help_text="是否为admin")
    DATASCOPE_CHOICES = (
        (0, "仅本人数据权限"),
        (1, "本部门及以下数据权限"),
        (2, "本部门数据权限"),
        (3, "全部数据权限"),
        (4, "自定数据权限"),
    )
    data_range = models.IntegerField(default=0, choices=DATASCOPE_CHOICES, verbose_name="数据权限范围", help_text="数据权限范围")
    remark = models.TextField(verbose_name="备注", help_text="备注", null=True, blank=True)
    dept = models.ManyToManyField(to='Dept', blank=True, verbose_name='数据权限-关联权限', db_constraint=False, help_text="数据权限-关联权限")
    menu = models.ManyToManyField(to='Menu', verbose_name='关联菜单', db_constraint=False, help_text="关联菜单")
    permission = models.ManyToManyField(to='MenuButton', verbose_name='关联菜单的接口按钮', db_constraint=False,
                                        help_text="关联菜单的接口按钮")

    class Meta:
        db_table = table_prefix + 'system_role'
        verbose_name = '角色表'
        verbose_name_plural = verbose_name
        ordering = ('sort',)
        
# dept更改为权限类
class Dept(CoreModel):
    name = models.CharField(max_length=64, verbose_name="子权限", help_text="子权限")
    sort = models.IntegerField(default=1, verbose_name="排序", help_text="排序")
    status = models.BooleanField(default=True, verbose_name="状态", null=True, blank=True, help_text="状态")
    parent = models.ForeignKey(to='Dept', on_delete=models.CASCADE, default=None, verbose_name="总权限",
                               db_constraint=False, null=True, blank=True, help_text="总权限")
    
    class Meta:
        db_table = table_prefix + "system_dept"
        verbose_name = '权限表'
        verbose_name_plural = verbose_name
        ordering = ('sort',)

def get_dept(name):
    return Dept.objects.filter(name=name).values('id')

# 新增类教室
class Room(CoreModel):
    name = models.CharField(max_length=64, verbose_name="教室名称", help_text="教室名称")
    sort = models.IntegerField(default=1, verbose_name="排序", help_text="排序")
    owner = models.CharField(max_length=32, verbose_name="负责人", null=True, blank=True, help_text="负责人")
    phone = models.CharField(max_length=32, verbose_name="联系电话", null=True, blank=True, help_text="联系电话")
    email = models.EmailField(max_length=32, verbose_name="邮箱", null=True, blank=True, help_text="邮箱")
    tools = models.CharField(max_length=32, verbose_name="设备", null=True, blank=True, help_text="设备")
    message = models.CharField(max_length=32, verbose_name="使用须知", null=True, blank=True, help_text="使用须知")
    status = models.BooleanField(default=True, verbose_name="教室状态", null=True, blank=True, help_text="教室状态")
    large = models.IntegerField(default=0, verbose_name="教室容量", null=True, blank=True, help_text="教室容量")
    uses = models.CharField(max_length=16, default="0.00%", verbose_name="使用情况", help_text="使用情况")
    parent = models.ForeignKey(to='Room', on_delete=models.CASCADE, default=None, verbose_name="上级教室",
                               db_constraint=False, null=True, blank=True, help_text="上级教室")
    avatar = models.CharField(max_length=255, verbose_name="出勤照片", null=True, blank=True, help_text="出勤照片")
    number = models.IntegerField(default=0, verbose_name="出勤人数", help_text="出勤人数")

    def set_dept(self):
        id = get_dept("学生")
        self.dept_belong_id = id

    def set_number_uses(self):
        if self.avatar != None and len(self.avatar) != 0:
            self.number = face_identify(self.avatar)
            if self.large != 0:
                self.uses =  '{:.2%}'.format(self.number/self.large)
        else:
            self.number = 0

    class Meta:
        db_table = table_prefix + "system_room"
        verbose_name = '教室表'
        verbose_name_plural = verbose_name
        ordering = ('sort',)

# 新增类预订
class Book(CoreModel):
    booker = models.CharField(max_length=40, blank=True, verbose_name="姓名", help_text="姓名")
    name = models.CharField(max_length=64, null=True, blank=True, verbose_name="教室名称", help_text="教室名称")
    phone = models.CharField(max_length=32, verbose_name="联系电话", null=True, blank=True, help_text="联系电话")
    email = models.EmailField(max_length=32, verbose_name="邮箱", null=True, blank=True, help_text="邮箱")
    need = models.BooleanField(default=True, verbose_name="教室状态", null=True, blank=True, help_text="教室状态")
    opinion = models.IntegerField(default=0, verbose_name="管理员审批", help_text="管理员审批")
    begin_date = models.DateTimeField(editable=True, blank=True, null=True, verbose_name="预订日期", help_text="预订日期")
    #begin_time = models.TimeField(editable=True, blank=True, verbose_name="预订时间", help_text="预订时间")
    end_time = models.DateTimeField(editable=True, blank=True, null=True, verbose_name="结束时间", help_text="结束时间")
    reason = models.CharField(max_length=256, blank=True, verbose_name="申请理由", help_text="申请理由")
    sort = models.IntegerField(default=1, verbose_name="显示排序", help_text="显示排序")
    parent = models.ForeignKey(to='Room', on_delete=models.CASCADE, default=None, verbose_name="上级教室",
                               db_constraint=False, null=True, blank=True, help_text="上级教室")
    role = models.ForeignKey(to='Role', verbose_name='角色', on_delete=models.PROTECT, db_constraint=False, null=True,
                             blank=True, help_text="角色")
    
    def set_dept(self):
        id = get_dept("学生")
        self.dept_belong_id = id

    class Meta:
        db_table = table_prefix + "system_book"
        verbose_name = '预定表'
        verbose_name_plural = verbose_name
        ordering = ('sort',)

# 新增类出勤
class Student(CoreModel):
    name = models.CharField(max_length=64, blank=False, verbose_name="课程名称", help_text="课程名称")
    avatar = models.CharField(max_length=255, verbose_name="出勤照片", null=True, blank=True, help_text="出勤照片")
    number = models.IntegerField(default=0, verbose_name="出勤人数", help_text="出勤人数")
    sort = models.IntegerField(default=1, verbose_name="显示排序", help_text="显示排序")
    absence = models.CharField(max_length=255, verbose_name="缺勤名单", null=True, blank=True, help_text="缺勤名单")

    def set_dept(self):
        id = get_dept("教师")
        self.dept_belong_id = id

    def identifity(self):
        if self.avatar != None and len(self.avatar) != 0:
            name_list = list(Course.objects.filter(cname__exact=self.name).values_list('name', flat=True))
            self.number, self.absence, absence_list = pic(self.avatar, self.name, name_list)
            # 发送邮件
            for absent in absence_list:
                print("absent:", absent)
                email = list(Course.objects.filter(name__exact = absent).values_list('email', flat=True))
                print("email:", email)
                if email != [''] and email != [None]:
                    send_email_demo(email, self.name, absent)
        else:
            self.number = 0

    class Meta:
        db_table = table_prefix + "system_student"
        verbose_name = '出勤表'
        verbose_name_plural = verbose_name
        ordering = ('sort',)

#新增类选课
class Course(CoreModel):
    name = models.CharField(max_length=64, blank=False, verbose_name="姓名", help_text="姓名")
    avatar = models.CharField(max_length=255, verbose_name="学生照片", null=True, blank=True, help_text="学生照片")
    email = models.EmailField(max_length=255, verbose_name="邮箱", null=True, blank=True, help_text="邮箱")
    cname = models.CharField(max_length=64, blank=True, verbose_name="课程名称", help_text="课程名称")
    sort = models.IntegerField(default=1, verbose_name="显示排序", help_text="显示排序")

    def set_dept(self):
        id = get_dept("教师")
        self.dept_belong_id = id

    def regist(self):
        registeredIdentity(self.avatar, self.name, self.cname)

    class Meta:
        db_table = table_prefix + "system_course"
        verbose_name = '选课表'
        verbose_name_plural = verbose_name
        ordering = ('sort',)


#新增类信息（排课）
class Message(CoreModel):
    name = models.CharField(max_length=64, blank=False, verbose_name="课程名", help_text="课程名")
    cclass = models.CharField(max_length=255, null=True, blank=True,verbose_name="上课班级", help_text="上课班级")
    teacher = models.CharField(max_length=64, blank=True, verbose_name="任课教师", help_text="任课教师")
    num = models.IntegerField(default=0, blank=True, verbose_name="上课次数", help_text="上课次数")
    roomID = models.IntegerField(default=0, null=True, blank=True, verbose_name="教室ID", help_text="教室ID")
    weekDay = models.IntegerField(default=0, null=True, blank=True, verbose_name="星期", help_text="星期")
    slot = models.IntegerField(default=0, null=True, blank=True, verbose_name="时间", help_text="时间")
    sort = models.IntegerField(default=1, verbose_name="显示排序", help_text="显示排序")

    def set_dept(self):
        id = get_dept("管理员")
        self.dept_belong_id = id

    class Meta:
        db_table = table_prefix + "system_message"
        verbose_name = '信息表'
        verbose_name_plural = verbose_name
        ordering = ('sort',)

#新增类课表管理
class Kecheng(CoreModel):
    name = models.CharField(max_length=64, blank=False, verbose_name="班级名称", help_text="班级名称")
    image = models.CharField(max_length=255, verbose_name="出勤照片", null=True, blank=True, help_text="出勤照片")    
    sort = models.IntegerField(default=1, verbose_name="显示排序", help_text="显示排序")
    
    def set_dept(self):
        id = get_dept("学生")
        self.dept_belong_id = id

    def set(self):
        img = 'http://127.0.0.1:8000/media/class/' + self.name + '.jpg'
        path = str(settings.BASE_DIR).replace("\\","/") + '/media/class/' + self.name + '.jpg'
        if os.path.exists(path):
            self.image = img

    class Meta:
        db_table = table_prefix + "system_kecheng"
        verbose_name = '课表表'
        verbose_name_plural = verbose_name
        ordering = ('sort',)

class Button(CoreModel):
    name = models.CharField(max_length=64, unique=True, verbose_name="权限名称", help_text="权限名称")
    value = models.CharField(max_length=64, unique=True, verbose_name="权限值", help_text="权限值")

    class Meta:
        db_table = table_prefix + "system_button"
        verbose_name = '权限标识表'
        verbose_name_plural = verbose_name
        ordering = ('-name',)


class Menu(CoreModel):
    parent = models.ForeignKey(to='Menu', on_delete=models.CASCADE, verbose_name="上级菜单", null=True, blank=True,
                               db_constraint=False, help_text="上级菜单")
    icon = models.CharField(max_length=64, verbose_name="菜单图标", null=True, blank=True, help_text="菜单图标")
    name = models.CharField(max_length=64, verbose_name="菜单名称", help_text="菜单名称")
    sort = models.IntegerField(default=1, verbose_name="显示排序", null=True, blank=True, help_text="显示排序")
    ISLINK_CHOICES = (
        (0, "否"),
        (1, "是"),
    )
    is_link = models.BooleanField(default=False, verbose_name="是否外链", help_text="是否外链")
    is_catalog = models.BooleanField(default=False, verbose_name="是否目录", help_text="是否目录")
    web_path = models.CharField(max_length=128, verbose_name="路由地址", null=True, blank=True, help_text="路由地址")
    component = models.CharField(max_length=128, verbose_name="组件地址", null=True, blank=True, help_text="组件地址")
    component_name = models.CharField(max_length=50, verbose_name="组件名称", null=True, blank=True, help_text="组件名称")
    status = models.BooleanField(default=True, blank=True, verbose_name="菜单状态", help_text="菜单状态")
    cache = models.BooleanField(default=False, blank=True, verbose_name="是否页面缓存", help_text="是否页面缓存")
    visible = models.BooleanField(default=True, blank=True, verbose_name="侧边栏中是否显示", help_text="侧边栏中是否显示")

    class Meta:
        db_table = table_prefix + "system_menu"
        verbose_name = '菜单表'
        verbose_name_plural = verbose_name
        ordering = ('sort',)


class MenuButton(CoreModel):
    menu = models.ForeignKey(to="Menu", db_constraint=False, related_name="menuPermission", on_delete=models.CASCADE,
                             verbose_name="关联菜单", help_text='关联菜单')
    name = models.CharField(max_length=64, verbose_name="名称", help_text="名称")
    value = models.CharField(max_length=64, verbose_name="权限值", help_text="权限值")
    api = models.CharField(max_length=200, verbose_name="接口地址", help_text="接口地址")
    METHOD_CHOICES = (
        (0, "GET"),
        (1, "POST"),
        (2, "PUT"),
        (3, "DELETE"),
    )
    method = models.IntegerField(default=0, verbose_name="接口请求方法", null=True, blank=True, help_text="接口请求方法")

    class Meta:
        db_table = table_prefix + "system_menu_button"
        verbose_name = '菜单权限表'
        verbose_name_plural = verbose_name
        ordering = ('-name',)


class Dictionary(CoreModel):
    code = models.CharField(max_length=100, blank=True, null=True, verbose_name="编码", help_text="编码")
    label = models.CharField(max_length=100, blank=True, null=True, verbose_name="显示名称", help_text="显示名称")
    value = models.CharField(max_length=100, blank=True, null=True, verbose_name="实际值", help_text="实际值")
    parent = models.ForeignKey(to='self', related_name='sublist', db_constraint=False, on_delete=models.PROTECT,
                               blank=True, null=True,
                               verbose_name="父级", help_text="父级")
    status = models.BooleanField(default=True, blank=True, verbose_name="状态", help_text="状态")
    sort = models.IntegerField(default=1, verbose_name="显示排序", null=True, blank=True, help_text="显示排序")
    remark = models.CharField(max_length=2000, blank=True, null=True, verbose_name="备注", help_text="备注")

    class Meta:
        db_table = table_prefix + 'dictionary'
        verbose_name = "字典表"
        verbose_name_plural = verbose_name
        ordering = ('sort',)


class OperationLog(CoreModel):
    request_modular = models.CharField(max_length=64, verbose_name="请求模块", null=True, blank=True, help_text="请求模块")
    request_path = models.CharField(max_length=400, verbose_name="请求地址", null=True, blank=True, help_text="请求地址")
    request_body = models.TextField(verbose_name="请求参数", null=True, blank=True, help_text="请求参数")
    request_method = models.CharField(max_length=8, verbose_name="请求方式", null=True, blank=True, help_text="请求方式")
    request_msg = models.TextField(verbose_name="操作说明", null=True, blank=True, help_text="操作说明")
    request_ip = models.CharField(max_length=32, verbose_name="请求ip地址", null=True, blank=True, help_text="请求ip地址")
    request_browser = models.CharField(max_length=64, verbose_name="请求浏览器", null=True, blank=True, help_text="请求浏览器")
    response_code = models.CharField(max_length=32, verbose_name="响应状态码", null=True, blank=True, help_text="响应状态码")
    request_os = models.CharField(max_length=64, verbose_name="操作系统", null=True, blank=True, help_text="操作系统")
    json_result = models.TextField(verbose_name="返回信息", null=True, blank=True, help_text="返回信息")
    status = models.BooleanField(default=False, verbose_name="响应状态", help_text="响应状态")

    class Meta:
        db_table = table_prefix + 'system_operation_log'
        verbose_name = '操作日志'
        verbose_name_plural = verbose_name
        ordering = ('-create_datetime',)


def media_file_name(instance, filename):
    h = instance.md5sum
    basename, ext = os.path.splitext(filename)
    return os.path.join('files', h[0:1], h[1:2], h + ext.lower())


class FileList(CoreModel):
    name = models.CharField(max_length=50, null=True, blank=True, verbose_name="名称", help_text="名称")
    url = models.FileField(upload_to=media_file_name)
    md5sum = models.CharField(max_length=36, blank=True, verbose_name="文件md5", help_text="文件md5")

    def save(self, *args, **kwargs):
        if not self.md5sum:  # file is new
            md5 = hashlib.md5()
            for chunk in self.url.chunks():
                md5.update(chunk)
            self.md5sum = md5.hexdigest()
        super(FileList, self).save(*args, **kwargs)

    class Meta:
        db_table = table_prefix + 'file_list'
        verbose_name = '文件管理'
        verbose_name_plural = verbose_name
        ordering = ('-create_datetime',)


class Area(CoreModel):
    name = models.CharField(max_length=100, verbose_name="名称", help_text="名称")
    code = models.CharField(max_length=20, verbose_name="地区编码", help_text="地区编码", unique=True, db_index=True)
    level = models.BigIntegerField(verbose_name="地区层级(1省份 2城市 3区县 4乡级)", help_text="地区层级(1省份 2城市 3区县 4乡级)")
    pinyin = models.CharField(max_length=255, verbose_name="拼音", help_text="拼音")
    initials = models.CharField(max_length=20, verbose_name="首字母", help_text="首字母")
    enable = models.BooleanField(default=True, verbose_name="是否启用", help_text="是否启用")
    pcode = models.ForeignKey(to='self', verbose_name='父地区编码', to_field="code", on_delete=models.CASCADE,
                              db_constraint=False, null=True, blank=True, help_text="父地区编码")

    class Meta:
        db_table = table_prefix + "area"
        verbose_name = '地区表'
        verbose_name_plural = verbose_name
        ordering = ('code',)

    def __str__(self):
        return f"{self.name}"


class ApiWhiteList(CoreModel):
    url = models.CharField(max_length=200, help_text="url地址", verbose_name="url")
    METHOD_CHOICES = (
        (0, "GET"),
        (1, "POST"),
        (2, "PUT"),
        (3, "DELETE"),
    )
    method = models.IntegerField(default=0, verbose_name="接口请求方法", null=True, blank=True, help_text="接口请求方法")
    enable_datasource = models.BooleanField(default=True, verbose_name="激活数据权限", help_text="激活数据权限", blank=True)

    class Meta:
        db_table = table_prefix + "api_white_list"
        verbose_name = '接口白名单'
        verbose_name_plural = verbose_name
        ordering = ('-create_datetime',)


class SystemConfig(CoreModel):
    parent = models.ForeignKey(to='self', verbose_name='父级', on_delete=models.CASCADE,
                               db_constraint=False, null=True, blank=True, help_text="父级")
    title = models.CharField(max_length=50, verbose_name="标题", help_text="标题")
    key = models.CharField(max_length=20, verbose_name="键", help_text="键")
    value = models.JSONField(max_length=100, verbose_name="值", help_text="值", null=True, blank=True)
    sort = models.IntegerField(default=0, verbose_name="排序", help_text="排序", blank=True)
    status = models.BooleanField(default=False, verbose_name="启用状态", help_text="启用状态")
    data_options = models.JSONField(verbose_name="数据options", help_text="数据options", null=True, blank=True)
    FORM_ITEM_TYPE_LIST = (
        (0, 'text'),
        (1, 'textarea'),
        (2, 'number'),
        (3, 'select'),
        (4, 'radio'),
        (5, 'checkbox'),
        (6, 'date'),
        (7, 'datetime'),
        (8, 'time'),
        (9, 'imgs'),
        (10, 'files'),
        (11, 'array'),
        (12, 'foreignkey'),
        (13, 'manytomany'),
    )
    form_item_type = models.IntegerField(choices=FORM_ITEM_TYPE_LIST, verbose_name="表单类型", help_text="表单类型", default=0,
                                         blank=True)
    rule = models.JSONField(null=True, blank=True, verbose_name="校验规则", help_text="校验规则")
    placeholder = models.CharField(max_length=50, null=True, blank=True, verbose_name="提示信息", help_text="提示信息")
    setting = models.JSONField(null=True, blank=True, verbose_name="配置", help_text="配置")

    class Meta:
        db_table = table_prefix + "system_config"
        verbose_name = '系统配置表'
        verbose_name_plural = verbose_name
        ordering = ('sort',)

    def __str__(self):
        return f"{self.title}"


class LoginLog(CoreModel):
    LOGIN_TYPE_CHOICES = (
        (1, '普通登录'),
    )
    username = models.CharField(max_length=32, verbose_name="登录用户名", null=True, blank=True, help_text="登录用户名")
    ip = models.CharField(max_length=32, verbose_name="登录ip", null=True, blank=True, help_text="登录ip")
    agent = models.TextField(verbose_name="agent信息", null=True, blank=True, help_text="agent信息")
    browser = models.CharField(max_length=200, verbose_name="浏览器名", null=True, blank=True, help_text="浏览器名")
    os = models.CharField(max_length=200, verbose_name="操作系统", null=True, blank=True, help_text="操作系统")
    continent = models.CharField(max_length=50, verbose_name="州", null=True, blank=True, help_text="州")
    country = models.CharField(max_length=50, verbose_name="国家", null=True, blank=True, help_text="国家")
    province = models.CharField(max_length=50, verbose_name="省份", null=True, blank=True, help_text="省份")
    city = models.CharField(max_length=50, verbose_name="城市", null=True, blank=True, help_text="城市")
    district = models.CharField(max_length=50, verbose_name="县区", null=True, blank=True, help_text="县区")
    isp = models.CharField(max_length=50, verbose_name="运营商", null=True, blank=True, help_text="运营商")
    area_code = models.CharField(max_length=50, verbose_name="区域代码", null=True, blank=True, help_text="区域代码")
    country_english = models.CharField(max_length=50, verbose_name="英文全称", null=True, blank=True, help_text="英文全称")
    country_code = models.CharField(max_length=50, verbose_name="简称", null=True, blank=True, help_text="简称")
    longitude = models.CharField(max_length=50, verbose_name="经度", null=True, blank=True, help_text="经度")
    latitude = models.CharField(max_length=50, verbose_name="纬度", null=True, blank=True, help_text="纬度")
    login_type = models.IntegerField(default=1, choices=LOGIN_TYPE_CHOICES, verbose_name="登录类型", help_text="登录类型")

    class Meta:
        db_table = table_prefix + 'system_login_log'
        verbose_name = '登录日志'
        verbose_name_plural = verbose_name
        ordering = ('-create_datetime',)
