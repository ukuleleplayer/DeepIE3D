# Backend part of DeepIE3D

Backend serving the pretrained generator of DeepIE3D. The generator can be from any GAN type as long as the output is a 3D array of size 64X64X64.

The backend is also responsible for doing evolution on incoming latent vectors. 

If you like [Google App Engine](https://cloud.google.com/appengine/), just run `gcloud app deploy` from the root of this folder and you'll have yourself an application running.

Remember to change allowed URL origins in [main.py](main.py)

If you're too lazy to train your own model, two pretrained models can be found here:

1. [Planes](https://drive.google.com/open?id=14k1RbKmnRATSKqk_zlxJgt_jZN8Asx_c) (Best - trained more extensively)
2. [Chairs](https://drive.google.com/open?id=1J1gjH6YU64Ehgw9kJlg-qAEx6dr3HM0x) (Not perfect but it works)