import os
import torch
from train import initialize_generator
from utils import generate_random_tensors, generate_binvox_file
from argparser import Argparser


def main():
    """
    Entrypoint for test

    Creates 6 binvox files using a specified generator
    """
    test_no = 0
    args = Argparser().args
    g_model = initialize_generator(args).eval()
    if not os.path.exists('./test'):
        os.mkdir('./test')
    with torch.set_grad_enabled(False):
        zs = generate_random_tensors(6, args)
        for z in zs:
            m = g_model(z)
            generate_binvox_file(m, f'./test/{test_no}', args.cube_len)
            test_no += 1


if __name__ == '__main__':
    main()
