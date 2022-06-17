# -*- coding: utf-8 -*-

"""
@author: 葛怡梦
@Remark: 人脸识别
@inset: 陈佳婧
"""
import os
from dvadmin.system.models import Message
from dvadmin.system.models import Kecheng
from django.conf import settings

import copy
import numpy as np
import prettytable
import xlrd
from PIL import Image, ImageFont, ImageDraw


# ----------------------------------------------------------------- #
class Schedule:
    """Class Schedule.
    定义一个课程类，这个类包含了课程、班级、教师、教室、星期、时间几个属性，
    其中前三个是我们自定义的，后面三个是需要算法来优化的。
    """
    def __init__(self, courseId, classId, teacherId):
        """Init
        Arguments:
            courseId: int, unique course id.
            classId: int, unique class id.
            teacherId: int, unique teacher id.
        """
        self.courseId = courseId
        self.classId = classId
        self.teacherId = teacherId

        self.roomId = 0
        self.weekDay = 0
        self.slot = 0

    def random_init(self, roomRange):
        """random init.
        返回随机整型
        numpy.random.randint(low, high=None, size=None, dtype='l')


        Arguments:
            roomSize: int, number of classrooms.
        """
        self.roomId = np.random.randint(1, roomRange + 1, 1)[0]
        self.weekDay = np.random.randint(1, 6, 1)[0]
        self.slot = np.random.randint(1, 6, 1)[0]

######################################################################


"""
接下来定义cost函数，这个函数用来计算课表种群的冲突。
当被测试课表冲突为0的时候，这个课表就是个符合规定的课表。冲突检测遵循下面几条规则：
同一个教室在同一个时间只能有一门课。
同一个班级在同一个时间只能有一门课 。
同一个教师在同一个时间只能有一门课。
同一个班级在同一天不能有相同的课。
"""


def schedule_cost(population, elite):
    """calculate conflict of class schedules.

    Arguments:
        population: List, population of class schedules.
        elite: int, number of best result.

    Returns:
        index of best result.
        best conflict score.
    """
    conflicts = []
    n = len(population[0])

    for p in population:
        conflict = 0
        for i in range(0, n - 1):
            for j in range(i + 1, n):
                # check course in same time and same room
                if p[i].roomId == p[j].roomId and p[i].weekDay == p[j].weekDay and p[i].slot == p[j].slot:
                    conflict += 1

                # check course for one class in same time
                classA = p[i].classId.split(',')
                classB = p[j].classId.split(',')
                for a in classA:
                    for b in classB:
                        if a == b and p[i].weekDay == p[j].weekDay and p[i].slot == p[j].slot:
                            conflict += 1

                # check course for one teacher in same time
                if p[i].teacherId == p[j].teacherId and p[i].weekDay == p[j].weekDay and p[i].slot == p[j].slot:
                    conflict += 1

                # check same course for one class in same day
                if p[i].classId == p[j].classId and p[i].courseId == p[j].courseId and p[i].weekDay == p[j].weekDay:
                    conflict += 1

        conflicts.append(conflict)

    index = np.array(conflicts).argsort()

    return index[: elite], conflicts[index[0]]


class GeneticOptimize:
    """Genetic Algorithm.
    """
    def __init__(self, popsize=30, mutprob=0.3, elite=5, maxiter=100):
        # size of population
        self.popsize = popsize
        # prob of mutation
        self.mutprob = mutprob
        # number of elite
        self.elite = elite
        # iter times
        self.maxiter = maxiter

    def init_population(self, schedules, roomRange):
        """Init population
            初始化种群
        Arguments:
            schedules: List, population of class schedules.
            roomRange: int, number of classrooms.
        """
        self.population = []

        for i in range(self.popsize):
            entity = []

            for s in schedules:
                s.random_init(roomRange)
                entity.append(copy.deepcopy(s))

            self.population.append(entity)

    def mutate(self, eiltePopulation, roomRange):
        """Mutation Operation
            变异：对Schedule对象中的某个可改变属性在允许范围内进行随机加减
        Arguments:
            eiltePopulation: List, population of elite schedules.
            roomRange: int, number of classrooms.

        Returns:
            ep: List, population after mutation.
        """
        e = np.random.randint(0, self.elite, 1)[0]
        pos = np.random.randint(0, 2, 1)[0]

        ep = copy.deepcopy(eiltePopulation[e])

        for p in ep:
            # 三种可变参数 教室、日期、课次
            pos = np.random.randint(0, 3, 1)[0]
            operation = np.random.rand()

            if pos == 0:
                p.roomId = self.addSub(p.roomId, operation, roomRange)
            if pos == 1:
                p.weekDay = self.addSub(p.weekDay, operation, 5)
            if pos == 2:
                p.slot = self.addSub(p.slot, operation, 6)

        return ep

    # 定义变化操作
    def addSub(self, value, op, valueRange):
        if op > 0.5:
            if value < valueRange:
                value += 1
            else:
                value -= 1
        else:
            if value - 1 > 0:
                value -= 1
            else:
                value += 1

        return value

    def crossover(self, eiltePopulation):
        """Crossover Operation
            交叉：随机对两个对象交换不同位置的属性
        Arguments:
            eiltePopulation: List, population of elite schedules.

        Returns:
            ep: List, population after crossover.
        """
        e1 = np.random.randint(0, self.elite, 1)[0]
        e2 = np.random.randint(0, self.elite, 1)[0]

        pos = np.random.randint(0, 2, 1)[0]

        ep1 = copy.deepcopy(eiltePopulation[e1])
        ep2 = eiltePopulation[e2]

        for p1, p2 in zip(ep1, ep2):
            if pos == 0:
                p1.weekDay = p2.weekDay
                p1.slot = p2.slot
            if pos == 1:
                p1.roomId = p2.roomId

        return ep1

    def evolution(self, schedules, roomRange):
        """evolution
        启动GA遗传算法进行优化
        Arguments:
            schedules: class schedules for optimization.
            elite: int, number of best result.

        Returns:
            index of best result.
            best conflict score.
        """
        # Main loop .
        bestScore = 0
        bestSchedule = None

        self.init_population(schedules, roomRange)

        for i in range(self.maxiter):
            eliteIndex, bestScore = schedule_cost(self.population, self.elite)

            print('Iter: {} | conflict: {}'.format(i + 1, bestScore))

            if bestScore == 0:
                bestSchedule = self.population[eliteIndex[0]]
                break

            # Start with the pure winners
            newPopulation = [self.population[index] for index in eliteIndex]

            # Add mutated and bred forms of the winners
            while len(newPopulation) < self.popsize:
                if np.random.rand() < self.mutprob:
                    # Mutation
                    newp = self.mutate(newPopulation, roomRange)
                else:
                    # Crossover
                    newp = self.crossover(newPopulation)

                newPopulation.append(newp)

            self.population = newPopulation

        return bestSchedule

# --------------------------------------------------------------------- #


'''
从表格读取课程信息
输入：
    1）filepath：要导入的表格地址
'''


def readFrom_xlsx(filepath):
    # 打开文件
    file_xlsx = xlrd.open_workbook(filepath, encoding_override="utf-8")
    # 获取所有sheet表
    all_sheet = file_xlsx.sheets()
    # 获取第一张表
    sheet1 = all_sheet[0]
    # 获取表的行数 课程的数量
    sheet1_rows = sheet1.nrows

    npyadress = str(settings.BASE_DIR).replace("\\","/") + '/media/class/schedules.npy'
    # 读取原有列表
    schedules = np.load(npyadress, allow_pickle=True)
    schedules = schedules.tolist()

    for i in range(1, sheet1_rows):
        course_name = sheet1.row_values(i)[0]
        class_name = sheet1.row_values(i)[1]
        teacher_name = sheet1.row_values(i)[2]
        lesson_per_week = sheet1.row_values(i)[3]
        for t in range(1, int(lesson_per_week)):
            schedules.append(Schedule(course_name, class_name, teacher_name))

    # 存储npy
    schedules = np.array(schedules)
    np.save('schedules.npy', schedules)


'''
直接新建课程信息
输入：
    course_name：
    class_name：
    teacher_name：
    lesson_per_week：
'''


def create_course(course_name, class_name, teacher_name, lesson_per_week, npypath):
    # 读取原有列表
    schedules = np.load(npypath, allow_pickle=True)
    schedules = schedules.tolist()

    # 改变列表
    for t in range(1, int(lesson_per_week)):
        schedules.append(Schedule(course_name, class_name, teacher_name))
    # 重新储存npy文件
    schedules = np.array(schedules)
    np.save(npypath, schedules)


'''
课程排课可视化
输入：
    schedule：所有课程
    room：教室名称
    savedir：课表保存地址
'''


def vis(res, room, savedir, name, choice):
    vis_res = []
    if (choice == 'room'):
        roomindex = room.index(name)
        for r in res:
            if r.roomId == (roomindex + 1):
                vis_res.append(r)
    elif (choice == 'class'):
        for r in res:
            classR = r.classId.split(',')
            for i in classR:
                if(i == name):
                    vis_res.append(r)
    elif(choice == 'teacher'):
        for r in res:
            if (r.teacherId == name):
                vis_res.append(r)

    col_labels = ['课程/星期', '1', '2', '3', '4', '5']
    table_vals = [[i + 1, '', '', '', '', ''] for i in range(6)]

    table = prettytable.PrettyTable(col_labels, hrules=prettytable.ALL)

    for s in vis_res:
        weekDay = s.weekDay
        slot = s.slot
        text = '课程: {} \n 上课班级: {} \n 教室: {} \n 任课教师: {}'.format(s.courseId, s.classId, str(room[s.roomId-1]), s.teacherId)
        table_vals[slot-1][weekDay] = text

    for row in table_vals:
        table.add_row(row)

    print(table)
    table_info = str(table)
    space = 10

    # PIL模块中，确定写入到图片中的文本字体
    font = ImageFont.truetype('C:/Windows/Fonts/simsun.ttc', 20, encoding='utf-8')
    # Image模块创建一个图片对象
    im = Image.new('RGB', (10, 10), (0, 0, 0, 0))
    # ImageDraw向图片中进行操作，写入文字或者插入线条都可以
    draw = ImageDraw.Draw(im, "RGB")
    # 根据插入图片中的文字内容和字体信息，来确定图片的最终大小
    img_size = draw.multiline_textsize(table_info, font=font)
    # 图片初始化的大小为10-10，现在根据图片内容要重新设置图片的大小
    im_new = im.resize((img_size[0]+space*2, img_size[1]+space*2))
    del draw
    del im
    draw = ImageDraw.Draw(im_new, 'RGB')
    # 批量写入到图片中，这里的multiline_text会自动识别换行符
    draw.multiline_text((space, space), table_info, fill=(255, 255, 255), font=font)
    # 生成图片
    im_new.save(savedir)
    # 由于目前只使用课表图片，所以暂时不做分类
    # 
    img = 'http://127.0.0.1:8000/media/class/' + name + '.jpg'
    Kecheng.objects.filter(name=name).update(image=img)
    del draw


def schedule_init(npypath):
    schedules = []
    # 储存npy文件
    schedules = np.array(schedules)
    np.save(npypath, schedules)
    # 读取数据库数据
    course_list = list(Message.objects.values_list('name', flat=True))
    class_list = list(Message.objects.values_list('cclass', flat=True))
    teacher_list = list(Message.objects.values_list('teacher', flat=True))
    lesson_times =list(Message.objects.values_list('num', flat=True))
    # 初始化课程信息
    for i in range(len(course_list)):
        course_name = course_list[i]
        class_name = class_list[i]
        teacher_name = teacher_list[i]
        lesson_per_week = lesson_times[i]
        create_course(course_name, class_name, teacher_name, lesson_per_week, npypath)


def scheduling(course_name, class_name, teacher_name, lesson_per_week):
    # 存储地址
    adress = str(settings.BASE_DIR).replace("\\","/") + '/media/class/'
    npypath = adress + 'schedules.npy'
    # 判断是否存在，不存在就创建，并初始化
    if not os.path.exists(npypath):
        schedule_init(npypath) 

    # 测试用例
    # course_name = '编译原理' 
    # class_name = '计2,计4,计1,计3'
    # teacher_name = '班晓娟'
    # lesson_per_week = 2
    create_course(course_name, class_name, teacher_name, lesson_per_week, npypath)

# ---------------------以上输入课程信息--------------------------- #
# ---------------------以下通过遗传算法排课----------------------- #
    # 读取原有列表
    schedules = np.load(npypath, allow_pickle=True)
    schedules = schedules.tolist()

    # optimization
    ga = GeneticOptimize(popsize=50, elite=10, maxiter=500)
    # 定义教室列表
    room = ['逸夫楼101', '逸夫楼102', '逸夫楼103', '逸夫楼201', '逸夫楼202']
            # '教学楼101', '教学楼102', '教学楼103', '教学楼201', '教学楼202',
            # '机电楼101', '机电楼201', '机电楼301', '机电楼401', '机电楼501',
            # '经管楼101', '经管楼201', '经管楼301', '经管楼401']
    roomNum = len(room)
    res = ga.evolution(schedules, roomNum)

    class_list = class_name.split(',')
    # 打印班级课表
    for name in class_list:
        savedir = adress + name + '.jpg'
        choice = 'class'
        vis(res, room, savedir, name, choice)
        
    
    # 以下为示例
    # 打印班级课表
    # # 设置图片的保存路径
    # savedir = '计1.jpg'
    # name = '计1'
    # choice = 'class'
    # vis(res, room, savedir, name, choice)

    # # 打印教室课表（教室需要是索引号）
    # savedir = '逸夫楼101.jpg'
    # name = '逸夫楼101'
    # choice = 'room'
    # vis(res, room, savedir, name, choice)

    # # 打印教师课表
    # savedir = 'teacher.jpg'
    # name = '何杰'
    # choice = 'teacher'
    # vis(res, room, savedir, name, choice)