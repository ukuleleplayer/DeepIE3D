import sys
import os
import multiprocessing as mp
import binvox_rw


def center(b, data_path):
	"""

	"""
    if b.endswith(".binvox"):
        with open(f'{data_path}/{b}', 'rb') as f:
            try:
                print(f'File: {b}')
                m = binvox_rw.read_as_3d_array(f)
                m.data = binvox_rw.dense_to_sparse(m.data)
                if len(m.data[0]) != 0 and len(m.data[0]) != 0 and len(m.data[0]) != 0:
                    translate_x = (
                        m.dims[0] - max(m.data[0]) - min(m.data[0]))//2
                    translate_y = (
                        m.dims[2] - max(m.data[2]) - min(m.data[2]))//2
                    for n in range(len(m.data[0])):
                        m.data[0][n] += translate_x
                        m.data[2][n] += translate_y
                m.write(f'{data_path}/{b}')
            except:
                print(f'Could not center file: {b}')


pool = mp.Pool(processes=mp.cpu_count())

dp = f'data/{sys.argv[1]}'
temp = [pool.apply_async(center, args=(b, dp)) for b in os.listdir(dp)]
[p.get() for p in temp]
