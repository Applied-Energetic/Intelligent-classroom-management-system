# -*- coding: utf-8 -*-

"""
@author: 葛怡梦
@Remark: 人脸识别
@inset: 陈佳婧
"""
import numpy as np
import cv2
import face_recognition
from django.conf import settings

# 	1）known_face_encodings：人脸库特征向量
#	2）known_face_names：人脸库名字标签
known_face_encodings, known_face_names = [], []
# Threshold = 0.65 # 人脸置信度阈值

'''
功能：计算两张图片的相似度，范围：[0,1]
输入：
	1）人脸A的特征向量
	2）人脸B的特征向量
输出：
	1）sim：AB的相似度
'''


def simcos(A, B):
	A = np.array(A)
	B = np.array(B)
	dist = np.linalg.norm(A - B)     # 二范数
	sim = 1.0 / (1.0 + dist)     #
	return sim


'''
功能：
输入：
	1）x:人脸库向量（n维）
	2）y：被测人脸的特征向量(1维)
输出：
	1)match：与人脸库匹配列表，如[False,True,True,False]
			表示被测人脸y与人脸库x的第2,3张图片匹配，与1,4不匹配
	2)max(ressim):最大相似度
'''


def compare_faces(x, y, Threshold):
	ressim = []
	match = [False]*len(x)
	for fet in x:
		sim = simcos(fet, y)
		ressim.append(sim)
	print(max(ressim))
	if max(ressim) > Threshold:  # 置信度阈值
		match[ressim.index(max(ressim))] = True
	print('complete compare')
	return match, max(ressim)


'''
注册身份
输入：
	1）libpath：人脸库地址
输出：
	1）known_face_encodings：人脸库特征向量
	2）known_face_names：人脸库名字标签
'''


def registeredIdentity(image_url, name):
	global known_face_encodings, known_face_names
	image_url1 = image_url[21:]
	BASE_DIR = str(settings.BASE_DIR)
	BASE_DIR = BASE_DIR.replace("\\","/")
	image_path = BASE_DIR + image_url1
	image = face_recognition.load_image_file(image_path)
	face_locations = face_recognition.face_locations(image)
	face_encoding = face_recognition.face_encodings(image, face_locations)[0]
	# face_encoding = face_recognition.face_encodings(image, face_locations)
	known_face_encodings.append(face_encoding)
	known_face_names.append(name)
	print ('complete register')
	print (known_face_names)
	

'''
输入：
	1）testimg：测试图片
	2）known_face_encodings：人脸库特征向量
	3）known_face_names：人脸库名字标签
输出：
	1）name_list：预测的名字
	2）score_list：相似度得分
	3）face_locations：人脸位置坐标
'''


def identityRecognition(testimg, known_face_encodings, known_face_names, Threshold):
	face_locations = face_recognition.face_locations(testimg)
	# face_locations = face_recognition.face_locations(testimg, model="cnn")
	face_encodings = face_recognition.face_encodings(testimg, face_locations)
	print(face_encodings)
	faceNum = len(face_locations)
	name_list, score_list = [], []
	retname, retscore = "Noface", 0
	for face_encoding in face_encodings:
		matches, score = compare_faces(known_face_encodings, face_encoding, Threshold)
		retname, retscore = "Unknow", 0
		if True in matches:
			first_match_index = matches.index(True)
			name = known_face_names[first_match_index]
			if score > retscore:
				retname = name
				retscore = score
		name_list.append(retname)
		score_list.append(retscore)
		print('complete recongnize')
	return name_list, score_list, face_locations, faceNum


'''
输入：
	1）img:未裁剪图片
	2）face_locations:人脸位置坐标
	3) name_list:预测的名字
输出：
	img:加框加年龄备注之后的画面
'''


def name_show(img, face_locations, name_list, score_list):
	index = 0
	for face_location in face_locations:
		y0 = face_location[0]
		x1 = face_location[1]
		y1 = face_location[2]
		x0 = face_location[3]

		cv2.rectangle(img, (x0, y0), (x1, y1), (0, 0, 255), 2)
		info = str(name_list[index])
		print('识别为：%s\n相似度：%2f' % (str(name_list[index]), score_list[index]))
		index = index + 1
		t_size = cv2.getTextSize(str(info), cv2.FONT_HERSHEY_PLAIN, 1, 2)[0]
		x2, y2 = x0 + t_size[0] + 3, y0 + t_size[1] + 4
		cv2.rectangle(img, (x0, y0), (x2, y2), (0, 0, 255), -1)  # -1填充作为文字框底色
		cv2.putText(img, info, (x0, y0 + t_size[1] + 4), cv2.FONT_HERSHEY_PLAIN, 1, (0, 0, 0), 1)
	return img


'''
功能：统计、校验名单
输入：
	1）需到课的名单
	2）检测到的名单
输出：
	1）到课名单
	2）缺课名单
'''


def statistic_name(faceNum, name_original, name_list):
	print("到课人数：", faceNum)
	print("到课名单：", name_list)
	print("缺课名单：", set(name_original)-set(name_list))


'''
功能：识别image身份
输入：
	1)image：被测图片
	2）libpath：人脸库地址
	3）save_dir：图片保存地址
	4)Threshold：人脸相似度阈值，Threshold越高识别越精准，但是检出率越低
'''


def pic(imagepath, libpath, save_dir, name_original, Threshold=0.68):
	image_original = cv2.imread(imagepath)
	known_face_encodings, known_face_names = registeredIdentity(libpath)
	name_list, score_list, face_locations, faceNum = identityRecognition(image_original, known_face_encodings, known_face_names, Threshold=Threshold)

	image = name_show(image_original, face_locations, name_list, score_list)
	statistic_name(faceNum, name_original, name_list)

	cv2.imwrite(save_dir, image)
	cv2.imshow('img', image)
	cv2.waitKey(0)


# if __name__ == '__main__':
#	name_list = ['ROSE','JISOO','LISA','JENNIE']
#	pic(imagepath = 'E:/face/bp3.jpg', libpath='E:/face/facelib/', save_dir='E:/face/tt_bp.jpg', name_original=name_list)

