import io
from torch import Tensor
import torch
import binvox_rw


def generate_z(z_size=200, dis='norm1', seed=None):
    """
    Generates a latent vector with a given distribution.
    Can be seeeded for test
    """
    if not seed is None:
        torch.manual_seed(seed)
    if dis == 'norm1':
        return Tensor(z_size).normal_(0.0, 1.0)
    elif dis == 'norm033':
        return Tensor(z_size).normal_(0.0, 0.33)
    elif dis == 'uni':
        return torch.rand(z_size)


def create_coords_from_voxels(voxels):
    """
    Creates a nonzero lsit of coords from voxels
    """
    nonzero = torch.nonzero(voxels >= 0.5)
    return nonzero.tolist()


def calculate_camera(voxelss):
    """
    Calculates min and max x,y,z based on several 3D models
    """
    min_x, min_y, min_z, max_x, max_y, max_z = 1337, 1337, 1337, -1337, -1337, -1337
    for voxels in voxelss:
        coords = create_coords_from_voxels(voxels)
        x_min, y_min, z_min, x_max, y_max, z_max = find_extremas(coords)
        min_x = x_min if x_min < min_x else min_x
        min_y = y_min if y_min < min_y else min_y
        min_z = z_min if z_min < min_z else min_z
        max_x = x_max if x_max > max_x else max_x
        max_y = y_max if y_max > max_y else max_y
        max_z = z_max if z_max > max_z else max_z

    return min_x, min_y, min_z, max_x, max_y, max_z


def find_extremas(coords):
    """
    Find the extremas in a 3D array
    """
    min_x, min_y, min_z, max_x, max_y, max_z = 1337, 1337, 1337, -1337, -1337, -1337
    for coord in coords:
        min_x = coord[0] if coord[0] < min_x else min_x
        min_y = coord[1] if coord[1] < min_y else min_y
        min_z = coord[2] if coord[2] < min_z else min_z
        max_x = coord[0] if coord[0] > max_x else max_x
        max_y = coord[1] if coord[1] > max_y else max_y
        max_z = coord[2] if coord[2] > max_z else max_z

    return min_x, min_y, min_z, max_x, max_y, max_z


def generate_binvox_file(voxels):
    """
    Given  a 3D tensor, create a binvox file
    """
    data = voxels.numpy()
    size = len(data[0])
    for x in range(size):
        for y in range(size):
            for z in range(size):
                data[x][y][z] = 1.0 if data[x][y][z] > 0.5 else 0.0
    size = len(voxels[0])
    dims = [size, size, size]
    scale = 1.0
    translate = [0.0, 0.0, 0.0]
    output = io.BytesIO()
    model = binvox_rw.Voxels(data, dims, translate, scale, 'xyz')
    model.write(output)
    output.seek(0)
    return output
