import sys
import os
import multiprocessing as mp
import binvox_rw

"""
Script taking a data directory as commandline argument, and concurrently centers all models within.
"""

def center(model_file, data_path):
	"""
    Centers a voxel 3D model in the y- and x axis.
	"""
    if model_file.endswith(".binvox"):
        with open(f'{data_path}/{model_file}', 'rb') as f:
            try:
                print(f'File: {model_file}')
                model = binvox_rw.read_as_3d_array(f)
                model.data = binvox_rw.dense_to_sparse(model.data)
                if len(model.data[0]) != 0 and len(model.data[0]) != 0 and len(model.data[0]) != 0:
                    translate_x = (
                        model.dims[0] - max(model.data[0]) - min(model.data[0]))//2
                    translate_y = (
                        m.dims[2] - max(model.data[2]) - min(model.data[2]))//2
                    for n in range(len(m.data[0])):
                        model.data[0][n] += translate_x
                        model.data[2][n] += translate_y
                m.write(f'{data_path}/{model_file}')
            except:
                print(f'Could not center file: {model_file}')


pool = mp.Pool(processes=mp.cpu_count())
data_path = sys.argv[1]
temp = [pool.apply_async(center, args=(model_file, data_path)) for model_file in os.listdir(data_path)]
[p.get() for p in temp]
