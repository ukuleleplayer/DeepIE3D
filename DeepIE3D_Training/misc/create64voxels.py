import os
from downscale import scale_n_times
import multiprocessing as mp

"""
Script concurrently dowscales entire data directory from 128 voxels to 64 voxels.
"""

def create(model_file, data_path, output_path):
    """
    Downscales voxel 3D model from 128 voxels to 64 voxels
    """
    try:
        if model_file.endswith(".binvox"):
            print(model_file)
            scale_n_times((f'{data_path}{model_file}'), (f'{output_path}{model_file}'), 1, 128)
    except:
        print(f'SomeThing went wrong with file: {model_file}')


data_path = sys.argv[1]
output_path = sys.argv[2]

pool = mp.Pool(processes=mp.cpu_count())
temp = [pool.apply_async(create, args=(model_file, data_path, output_path)) for model_file in os.listdir(data_path)]
[p.get() for p in temp]
