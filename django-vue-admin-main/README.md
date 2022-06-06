# Django-Vue-Admin

# 基于人脸识别的教室智能管理系统


* 🧑‍🤝‍🧑前端采用[D2Admin](https://github.com/d2-projects/d2-admin) 、[Vue](https://cn.vuejs.org/)、[ElementUI](https://element.eleme.cn/)。
* 👭后端采用 Python 语言 Django 框架以及强大的 [Django REST Framework](https://pypi.org/project/djangorestframework)。
* 👫权限认证使用[Django REST Framework SimpleJWT](https://pypi.org/project/djangorestframework-simplejwt)，支持多终端认证系统。

### 部署DVA系统

git clone https://gitee.com/xia-yue/classroom.git

#### 前端

##### 安装环境

1、VScode 社区版
https://code.visualstudio.com/

2、安装NPM
https://nodejs.org/en/
安装包下载后，一直点击next ，安装完成，打开cmd 输入 node -v 查看安装是否成功

3、安装mysql并新建数据库
dvapro

##### 进入项目目录

cd web

##### 安装依赖

npm install --registry=https://registry.npm.taobao.org

##### 启动服务

npm run dev

##### 浏览器访问 http://localhost:8080

### 后端

1. 进入项目目录 cd backend
2. 安装依赖环境
   pip3 install -r requirements.txt
3. 执行迁移命令：
   python manage.py makemigrations
   python manage.py migrate
4. 初始化数据
   python manage.py init
5. 初始化省市县数据:
   python manage.py init_area
6. 启动项目
   python manage.py runserver 0.0.0.0:8000

访问项目
访问地址：http://localhost:8080 (默认为此地址，如有修改请按照配置文件)
账号：superadmin 密码：admin12345
