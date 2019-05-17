import torch.nn as nn


class Generator(nn.Module):
    """
    Generator of a GAN
    """

    def __init__(self, args):
        super(Generator, self).__init__()
        self.z_size = args.z_size

        self.layer1 = nn.Sequential(
            nn.ConvTranspose3d(args.z_size, args.cube_len *
                               8, kernel_size=4, stride=2),
            nn.BatchNorm3d(args.cube_len*8),
            nn.ReLU()
        )
        self.layer2 = nn.Sequential(
            nn.ConvTranspose3d(args.cube_len*8, args.cube_len*4,
                               kernel_size=4, stride=2, padding=(1, 1, 1)),
            nn.BatchNorm3d(args.cube_len*4),
            nn.ReLU()
        )
        self.layer3 = nn.Sequential(
            nn.ConvTranspose3d(args.cube_len*4, args.cube_len*2,
                               kernel_size=4, stride=2, padding=(1, 1, 1)),
            nn.BatchNorm3d(args.cube_len*2),
            nn.ReLU()
        )
        self.layer4 = nn.Sequential(
            nn.ConvTranspose3d(args.cube_len*2, args.cube_len,
                               kernel_size=4, stride=2, padding=(1, 1, 1)),
            nn.BatchNorm3d(args.cube_len),
            nn.ReLU()
        )
        self.layer5 = nn.Sequential(
            nn.ConvTranspose3d(args.cube_len, 1, kernel_size=4,
                               stride=2, padding=(1, 1, 1)),
            nn.Sigmoid()
        )

    def forward(self, x):
        out = x.view(-1, self.z_size, 1, 1, 1)
        out = self.layer1(out)
        out = self.layer2(out)
        out = self.layer3(out)
        out = self.layer4(out)
        out = self.layer5(out)

        return out


class Discriminator(nn.Module):
    """
    Discriminator of a GAN
    """

    def __init__(self, args):
        super(Discriminator, self).__init__()

        self.layer1 = nn.Sequential(
            nn.Conv3d(1 if args.unpac else 2, args.cube_len, kernel_size=4,
                      stride=2, padding=(1, 1, 1)),
            nn.LeakyReLU(args.leak_value)
        )
        if args.gan_type in ['wgan-gp']:
            self.layer2 = nn.Sequential(
                nn.Conv3d(args.cube_len, args.cube_len*2,
                          kernel_size=4, stride=2, padding=(1, 1, 1)),
                nn.LeakyReLU(args.leak_value)
            )
        else:
            self.layer2 = nn.Sequential(
                nn.Conv3d(args.cube_len, args.cube_len*2,
                          kernel_size=4, stride=2, padding=(1, 1, 1)),
                nn.BatchNorm3d(args.cube_len*2),
                nn.LeakyReLU(args.leak_value)
            )
        if args.gan_type in ['wgan-gp']:
            self.layer3 = nn.Sequential(
                nn.Conv3d(args.cube_len*2, args.cube_len*4,
                          kernel_size=4, stride=2, padding=(1, 1, 1)),
                nn.LeakyReLU(args.leak_value)
            )
        else:
            self.layer3 = nn.Sequential(
                nn.Conv3d(args.cube_len*2, args.cube_len*4,
                          kernel_size=4, stride=2, padding=(1, 1, 1)),
                nn.BatchNorm3d(args.cube_len*4),
                nn.LeakyReLU(args.leak_value)
            )
        if args.gan_type in ['wgan-gp']:
            self.layer4 = nn.Sequential(
                nn.Conv3d(args.cube_len*4, args.cube_len*8,
                          kernel_size=4, stride=2, padding=(1, 1, 1)),
                nn.LeakyReLU(args.leak_value)
            )
        else:
            self.layer4 = nn.Sequential(
                nn.Conv3d(args.cube_len*4, args.cube_len*8,
                          kernel_size=4, stride=2, padding=(1, 1, 1)),
                nn.BatchNorm3d(args.cube_len*8),
                nn.LeakyReLU(args.leak_value)
            )
        if args.gan_type in ['wgan-gp']:
            self.layer5 = nn.Sequential(
                nn.Conv3d(args.cube_len*8, 1, kernel_size=4, stride=2),
            )
        else:
            self.layer5 = nn.Sequential(
                nn.Conv3d(args.cube_len*8, 1, kernel_size=4, stride=2),
                nn.Sigmoid()
            )

    def forward(self, x):
        out = self.layer1(x)
        out = self.layer2(out)
        out = self.layer3(out)
        out = self.layer4(out)
        out = self.layer5(out).view(-1)

        return out
