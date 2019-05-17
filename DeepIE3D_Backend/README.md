# Backend part of DeepIE3D

Backend serving the pretrained generator of DeepIE3D. The generator can be from any GAN type as long as the output is a 3D array of size 64X64X64.

The backend is also responsible for doing evolution on incoming latent vectors. 

If you like [Google App Engine](https://cloud.google.com/appengine/), just run `gcloud app deploy` from the root of this folder and you'll have yourself an application running.

Remember to change allowed URL origins in [main.py](main.py)
