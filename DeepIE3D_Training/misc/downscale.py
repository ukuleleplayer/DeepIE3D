import binvox_rw
import torch
import numpy as np
import utils
import os
from multiprocessing.dummy import Pool as ThreadPool

global pool
global voxels
global scaled_array


def scale_n_times(input_path, output_path, n, s):
    size = s
    global pool
    pool = ThreadPool(128)
    with open(input_path, 'rb') as f:
        m = binvox_rw.read_as_3d_array(f)
    global voxels
    global scaled_array
    voxels = m.data
    for i in range(n):
        size = size//2
        scaled_array = np.zeros((size, size, size))
        scale_down()
        voxels = scaled_array
    m.data = voxels
    m.dims = (size, size, size)
    pool.close()
    pool.join()
    m.write(output_path)


def scale_down():
    loop_length = len(voxels)
    scaled_array = np.zeros((loop_length//2, loop_length//2, loop_length//2))
    for x in range(0, loop_length, 2):
        for y in range(0, loop_length, 2):
            args = [(x, y, z) for z in range(0, loop_length, 2)]
            pool.starmap(count_majority, args)


def count_majority(x, y, z):
    v0 = voxels[x][y][z]
    v1 = voxels[x+1][y][z]
    v2 = voxels[x][y+1][z]
    v3 = voxels[x][y][z+1]
    v4 = voxels[x+1][y+1][z]
    v5 = voxels[x+1][y][z+1]
    v6 = voxels[x][y+1][z+1]
    v7 = voxels[x+1][y+1][z+1]
    scaled_array[x//2][y//2][z //
                             2] = int(list([v0, v1, v2, v3, v4, v5, v6, v7]).count(True) >= 4)
