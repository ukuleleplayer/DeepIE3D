import os
import torch
from torch.utils import data
from numpy import asarray, float32
import binvox_rw


def get_voxels_from_binvox(path):
    """
    Get voxels as numpy from a binvox file
    """
    voxels = binvox_rw.read_as_3d_array(path).data
    return voxels


def generate_z(args):
    """
    Generate a batch of latent vectors
    """
    if args.z_dis == 'norm1':
        Z = torch.Tensor(args.batch_size, args.z_size).normal_(0.0, 1.0)
    elif args.z_dis == 'norm033':
        Z = torch.Tensor(args.batch_size, args.z_size).normal_(0.0, 0.33)
    elif args.z_dis == 'uni':
        Z = torch.randn(args.batch_size, args.z_size)
    return Z


class ShapeNetDataset(data.Dataset):
    """Custom Dataset compatible with torch.utils.data.DataLoader"""

    def __init__(self, root):
        self.data = []
        self.root = root
        listdir = os.listdir(self.root)
        for _, path in enumerate(listdir):
            if path.endswith('.binvox'):
                with open(self.root + path, 'rb') as f:
                    self.data.append(torch.FloatTensor(
                        asarray(get_voxels_from_binvox(f), dtype=float32)))

    def __getitem__(self, index):
        return self.data[index]

    def __len__(self):
        return len(self.data)


def generate_binvox_file(voxels, file_path, dimension):
    """
    Generate a binvox file from voxels
    """
    voxels = torch.round(voxels.view(dimension, dimension, dimension))
    arr = voxels.numpy()
    size = len(arr)
    dims = [size, size, size]
    scale = 1.0
    translate = [0.0, 0.0, 0.0]
    model = binvox_rw.Voxels(arr, dims, translate, scale, 'xyz')
    model.write(f'{file_path}.binvox')


def generate_random_tensors(n, args, testing=False):
    """
    Generate n random latent vectors for testing
    """
    if testing:
        torch.manual_seed(999)
    if args.z_dis == 'norm1':
        return torch.rand(n, args.z_size).normal_(0.0, 1.0)
    elif args.z_dis == 'norm033':
        return torch.rand(n, args.z_size).normal_(0.0, 0.33)
    elif args.z_dis == 'uni':
        return torch.randn(n, args.z_size)
