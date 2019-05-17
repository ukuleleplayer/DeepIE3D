import os
from downscale import scale_n_times
import multiprocessing as mp


def create(b, dp):
    try:
        if b.endswith(".binvox"):
            print(b)
            scale_n_times((f'{dp}{b}'), (f'./data/plane64/{b}'), 1, 128)
    except:
        print(f'SomeThing went wrong with file: {b}')


dp = './data/plane/'

pool = mp.Pool(processes=mp.cpu_count())
temp = [pool.apply_async(create, args=(b, dp)) for b in os.listdir(dp)]
[p.get() for p in temp]
