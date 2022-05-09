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