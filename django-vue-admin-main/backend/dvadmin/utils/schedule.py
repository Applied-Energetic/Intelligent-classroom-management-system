# -*- coding: utf-8 -*-

"""
@author: 葛怡梦
@Remark: 人脸识别
@inset: 陈佳婧
"""

from dvadmin.system.models import Message

import copy
import numpy as np

from schedule import schedule_cost


# ----------------------------------------- #
# 遗传算法
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

# ----------------------------------------- #

def vis(schedule, room):
    """visualization Class Schedule.

    Arguments:
        schedule: List, Class Schedule
    """
    col_labels = ['课程/星期', '1', '2', '3', '4', '5']
    table_vals = [[i + 1, '', '', '', '', ''] for i in range(6)]

    table = prettytable.PrettyTable(col_labels, hrules=prettytable.ALL)

    for s in schedule:
        weekDay = s.weekDay
        slot = s.slot
        text = '课程: {} \n 上课班级: {} \n 教室: {} \n 任课教师: {}'.format(s.courseId, s.classId, str(room[s.roomId-1]), s.teacherId)
        table_vals[slot-1][weekDay] = text

    for row in table_vals:
        table.add_row(row)

    print(table)


def schedule():
    schedules = []

    # add schedule
    filepath = 'D:/work/大三下/软工课设/crsArrange/course1.xls'
    readFrom_xlsx(filepath, schedules)

    # optimization
    ga = GeneticOptimize(popsize=50, elite=10, maxiter=500)
    # 定义教室列表
    room = ['逸夫楼101', '逸夫楼102', '逸夫楼103', '逸夫楼201', '逸夫楼202']
            # '教学楼101', '教学楼102', '教学楼103', '教学楼201', '教学楼202',
            # '机电楼101', '机电楼201', '机电楼301', '机电楼401', '机电楼501',
            # '经管楼101', '经管楼201', '经管楼301', '经管楼401']
    roomNum = len(room)
    res = ga.evolution(schedules, roomNum)

    # 打印班级课表
    vis_res = []
    for r in res:
        classR = r.classId.split(',')
        for i in classR:
            if(i == '计1'):
                vis_res.append(r)
    vis(vis_res, room)

    # 打印教室课表（教室需要是索引号）
    vis_res = []
    roomindex = room.index('逸夫楼101')
    for r in res:
        if r.roomId == (roomindex + 1):
            vis_res.append(r)
    vis(vis_res, room)
