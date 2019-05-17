"""
Mass view binvox files
"""

import os
import sys

DATAPATH = 'test/'

for c in os.listdir(DATAPATH):
    print(c)
    if sys.platform == 'linux':
        os.system(f'viewvox {DATAPATH}{c}')
    else:
        os.system(f'./viewvox {DATAPATH}{c}')
