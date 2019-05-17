import argparse
import torch


class Argparser:
    """
    The actual argparser
    """

    def __init__(self):
        self.args = self.prepare_arg_parser().parse_args()

    def prepare_arg_parser(self):
        """
        Add all args to the argparser
        """
        arg_parser = argparse.ArgumentParser()

        arg_parser.add_argument('--gan_type', type=str, default="wgan-gp",
                                choices=["dcgan", "wgan-gp"], help='type of gan to train')
        arg_parser.add_argument(
            '--unpac', action='store_true', help='toggle PacGAN(2)')
        arg_parser.add_argument('--epochs', type=int, default=10000,
                                help='number of epochs to train')
        arg_parser.add_argument('--d_iter', type=int, default=5,
                                help='number of iteration to train discriminator')
        arg_parser.add_argument('--d_low_thresh', type=float, default=0.80,
                                help='keep on training DCGAN discriminator if below this threshold')
        arg_parser.add_argument('--d_high_thresh', type=float, default=0.99,
                                help='do not traing DCGAN discriminator if above this threshold')
        arg_parser.add_argument('--current_epoch', type=int, default=0,
                                help='current epoch training/epoch to start with')
        arg_parser.add_argument('--current_iteration', type=int, default=0,
                                help='current iteration in training/iteration to start with')
        arg_parser.add_argument('--batch_size', type=int, default=64,
                                help='size of the mini batch to be used')
        arg_parser.add_argument('--gp_lambda', type=int, default=10,
                                help='factor of which gp influences loss')
        arg_parser.add_argument('--z_size', type=int, default=200,
                                help='size of the latent vectors')
        arg_parser.add_argument('--g_lr', type=float, default=0.0001,
                                help='generator network learning rate')
        arg_parser.add_argument('--d_lr', type=float, default=0.0001,
                                help='discriminator network learning rate')
        arg_parser.add_argument('--betas', type=float, default=[0.0, 0.9], nargs=2,
                                help='value of betas in adam optimizer')
        arg_parser.add_argument('--z_dis', type=str, default="norm1",
                                choices=["norm1", "norm033", "uni"],
                                help='distribution to be used for z')
        arg_parser.add_argument('--leak_value', type=float, default=0.2,
                                help='leak value in leaky relu')
        arg_parser.add_argument('--cube_len', type=int, default=64,
                                help='cube length of voxels')
        arg_parser.add_argument('--d_thresh', type=float, default=0.8,
                                help='discriminator accuracy threshold')
        arg_parser.add_argument('--obj', type=str, default="plane",
                                help='training dataset object category')
        arg_parser.add_argument('--labels', type=str, default="noisy",
                                choices=["noisy", "hard", "d_hard"],
                                help='choose label type (noisy, hard, d-hard)')
        arg_parser.add_argument('--input_dir', type=str, default='data',
                                help='input path')
        arg_parser.add_argument('--models_path', type=str, default='models',
                                help='path in which to save the models')
        arg_parser.add_argument('--test_path', type=str, default='plane_g.tar',
                                help='path in which to fetch the test model')
        arg_parser.add_argument('--data_dir', type=str, default='plane64_256',
                                help='dataset load path')
        arg_parser.add_argument('--save_freq', type=int, default=200,
                                help='To save model for every n steps')
        arg_parser.add_argument('--device', type=str,
                                default="cuda" if torch.cuda.is_available() else "cpu",
                                help='use the given device (cuda/cpu) for training')
        return arg_parser
