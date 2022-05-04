# 基于人脸识别的教室智能管理系统

### 部署DVA系统
git clone https://gitee.com/xia-yue/classroom.git
输入你的用户名和密码即可克隆

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

4. 安装依赖环境
	pip3 install -r requirements.txt
5. 执行迁移命令：
	python manage.py makemigrations
	python manage.py migrate
6. 初始化数据
	python manage.py init
7. 初始化省市县数据:
	python manage.py init_area
8. 启动项目
	python manage.py runserver 0.0.0.0:8000

访问项目
访问地址：http://localhost:8080 (默认为此地址，如有修改请按照配置文件)
账号：superadmin 密码：admin123456