# -*- coding: utf-8 -*-

"""
@author: 葛怡梦
@Remark: 人脸识别

人脸识别库导入：

# 安装CMAKE（dlib编译依赖）
python -m pip install cmake --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple
# 安装Boost（dlib编译依赖）
python -m pip install boost -i https://pypi.tuna.tsinghua.edu.cn/simple
# 安装PySide2（PC上默认使用PySide2，而不是PyQt5）
python -m pip install pyside2 -i https://pypi.tuna.tsinghua.edu.cn/simple
# 安装opencv-python-headless
python -m pip install opencv-python-headless -i https://pypi.tuna.tsinghua.edu.cn/simple
# 安装face_recognition（依赖于dlib，安装前会自动下载并编译dlib）
python -m pip install face_recognition -i https://pypi.tuna.tsinghua.edu.cn/simple

(参考https://gitee.com/mxb360/fracs/)
"""

from msilib.schema import Class
from PIL import Image, ImageDraw
from django.conf import settings    # 图像操作
import face_recognition             # 人脸识别

import os               # 文件夹目录

def face_identify(image_url):
    # image_path = os.path.join(settings.MEDIA_ROOT,image_url)
    # image_path = os.path.join(image_url)
    image_url1 = image_url[21:]
    BASE_DIR = str(settings.BASE_DIR)
    BASE_DIR = BASE_DIR.replace("\\","/")
    image_path = BASE_DIR + image_url1

    image = face_recognition.load_image_file(image_path)
    
    # face_locations存储面部位置的元组，(top, right, bottom, left)
    face_locations = face_recognition.face_locations(image)
    print(face_locations)

    faceNum = len(face_locations)
    print(faceNum)

    # 创建PIL图像 允许图像处理
    pil_image = Image.fromarray(image, 'RGB')

    # 用红色边框标记，目的是之后的图像裁剪不会有标记边框
    img_with_red_box = pil_image.copy()
    img_draw = ImageDraw.Draw(img_with_red_box)  # 画图对象

    # 遍历每个人脸，并标注
    for face_location in face_locations:
        top = face_location[0]
        right = face_location[1]
        bottom = face_location[2]
        left = face_location[3]

        img_draw.rectangle(((left, top), (right, bottom)), fill=None, outline='red', width=3)

    # img_with_box_path = os.path.join(settings.MEDIA_ROOT,'face_id',image_url)
    # img_with_red_box.save(img_with_box_path)
    
    img_with_red_box.show() 

    return faceNum

#image_url = r"http://127.0.0.1:8000/media/files/6/a/6aba43be0fbabdd5712634e290ad6745_A44TbSa.jpg"
#image_url1 = image_url[21:]
#BASE_DIR = r"D:\work\classroom\django-vue-admin-main\backend"
#BASE_DIR = BASE_DIR.replace("\\","/")
#image_path = BASE_DIR + image_url1
#print (BASE_DIR)
#facenum = face_identify(image_url)
#print (facenum)

