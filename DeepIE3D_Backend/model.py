import torch.nn as nn


class Generator(nn.Module):
    """
    Generator of a GAN
    """

    def __init__(self, z_size, cube_len):
        super(Generator, self).__init__()
        self.z_size = z_size

        self.layer1 = nn.Sequential(
            nn.ConvTranspose3d(z_size, cube_len *
                               8, kernel_size=4, stride=2),
            nn.BatchNorm3d(cube_len*8),
            nn.ReLU()
        )
        self.layer2 = nn.Sequential(
            nn.ConvTranspose3d(cube_len*8, cube_len*4,
                               kernel_size=4, stride=2, padding=(1, 1, 1)),
            nn.BatchNorm3d(cube_len*4),
            nn.ReLU()
        )
        self.layer3 = nn.Sequential(
            nn.ConvTranspose3d(cube_len*4, cube_len*2,
                               kernel_size=4, stride=2, padding=(1, 1, 1)),
            nn.BatchNorm3d(cube_len*2),
            nn.ReLU()
        )
        self.layer4 = nn.Sequential(
            nn.ConvTranspose3d(cube_len*2, cube_len,
                               kernel_size=4, stride=2, padding=(1, 1, 1)),
            nn.BatchNorm3d(cube_len),
            nn.ReLU()
        )
        self.layer5 = nn.Sequential(
            nn.ConvTranspose3d(cube_len, 1, kernel_size=4,
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

    def __init__(self, unpac, cube_len, leak_value, gan_type):
        super(Discriminator, self).__init__()

        self.layer1 = nn.Sequential(
            nn.Conv3d(1 if unpac else 2, cube_len, kernel_size=4,
                      stride=2, padding=(1, 1, 1)),
            nn.LeakyReLU(leak_value)
        )
        if gan_type in ['wgan-gp']:
            self.layer2 = nn.Sequential(
                nn.Conv3d(cube_len, cube_len*2,
                          kernel_size=4, stride=2, padding=(1, 1, 1)),
                nn.LeakyReLU(leak_value)
            )
        else:
            self.layer2 = nn.Sequential(
                nn.Conv3d(cube_len, cube_len*2,
                          kernel_size=4, stride=2, padding=(1, 1, 1)),
                nn.BatchNorm3d(cube_len*2),
                nn.LeakyReLU(leak_value)
            )
        if gan_type in ['wgan-gp']:
            self.layer3 = nn.Sequential(
                nn.Conv3d(cube_len*2, cube_len*4,
                          kernel_size=4, stride=2, padding=(1, 1, 1)),
                nn.LeakyReLU(leak_value)
            )
        else:
            self.layer3 = nn.Sequential(
                nn.Conv3d(cube_len*2, cube_len*4,
                          kernel_size=4, stride=2, padding=(1, 1, 1)),
                nn.BatchNorm3d(cube_len*4),
                nn.LeakyReLU(leak_value)
            )
        if gan_type in ['wgan-gp']:
            self.layer4 = nn.Sequential(
                nn.Conv3d(cube_len*4, cube_len*8,
                          kernel_size=4, stride=2, padding=(1, 1, 1)),
                nn.LeakyReLU(leak_value)
            )
        else:
            self.layer4 = nn.Sequential(
                nn.Conv3d(cube_len*4, cube_len*8,
                          kernel_size=4, stride=2, padding=(1, 1, 1)),
                nn.BatchNorm3d(cube_len*8),
                nn.LeakyReLU(leak_value)
            )
        if gan_type in ['wgan-gp']:
            self.layer5 = nn.Sequential(
                nn.Conv3d(cube_len*8, 1, kernel_size=4, stride=2),
            )
        else:
            self.layer5 = nn.Sequential(
                nn.Conv3d(cube_len*8, 1, kernel_size=4, stride=2),
                nn.Sigmoid()
            )

    def forward(self, x):
        out = self.layer1(x)
        out = self.layer2(out)
        out = self.layer3(out)
        out = self.layer4(out)
        out = self.layer5(out).view(-1)

        return out
