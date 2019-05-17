# Training part of DeepIE3D

## What can I train?

You have four possibilities:
1. PacWGAN-GP2 (used in original DeepIE3D)
2. WGAN-GP
3. PacDCGAN2
4. DCGAN

## How do I get started?

Follow this guide:
1. Get some data from [ShapeNet](https://www.shapenet.org/ "ShapeNet's Homepage") - download in voxel format
2. Downscale the voxel models to 64 X 64 X 64 or make changes to [model.py](model.py) - script to downscale is included: [downscale.py](misc/downscale.py)
3. Place the downscaled models in a folder named "data"
4. You're now ready to train! To configure hyperparameters, please refer to [argparser.py](argparser.py)
5. If you don't wanna do the above, some training data has already been included; running [main.py](main.py) will work right away.

The trained model is usable together with the [DeepIE3D_Backend](https://github.com/ukuleleplayer/DeepIE3D/tree/master/DeepIE3D_Backend)
