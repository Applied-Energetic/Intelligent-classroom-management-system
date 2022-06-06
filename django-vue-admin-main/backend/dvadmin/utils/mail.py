"""
@author: 尚善蒲
@contact: applied_energetic@163.com
@Created on: 2022/5/29 
@Remark: 发送邮件功能
"""
#参考https://www.w3cschool.cn/article/17223331.html

from django.core.mail import send_mail
from application import settings
from django.shortcuts import HttpResponse
from django.core.mail import send_mail
#传入接收者的列表即可
#recipient_list: 一个字符串列表，每项都是一个邮箱地址。
def send_email_demo(target):
    from_who = settings.EMAIL_FROM  
    #发件人  已写在 配置中 可直接使用（163邮箱）
    to_who = target 
    #收件人 是一个列表 不限邮箱
    subject = '检测到未出勤情况，请尽快回复'  
    # 发送的标题
    message = '检测到未出勤情况，请尽快回复'  
    # 发送的消息
    send_mail(subject, message, from_who, [to_who])
    return HttpResponse("ok")


#python manage.py shell

# #进入Django Shell 使用电子邮件
# from django.core.mail import send_mail
# from application import settings
# send_mail(
#     subject='检测到未出勤情况，请尽快回复',
#     message='检测到未出勤情况，请尽快回复',
#     from_email=settings.EMAIL_HOST_USER,
#     recipient_list=['631526820@qq.com'])

"""
源码: send_mail 的源码 里面参数很多
    def send_mail(subject, message, from_email, recipient_list,
              fail_silently=False, auth_user=None, auth_password=None,
              connection=None, html_message=None):

"""