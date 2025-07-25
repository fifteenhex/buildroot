import os

import infra.basetest


class BaseTestDockerCompose(infra.basetest.BRTest):
    scripts = ["conf/docker-compose.yml",
               "tests/package/sample_python_docker.py"]
    config = \
        """
        BR2_x86_64=y
        BR2_x86_corei7=y
        BR2_TOOLCHAIN_EXTERNAL=y
        BR2_TOOLCHAIN_EXTERNAL_BOOTLIN_X86_64_CORE_I7_GLIBC_STABLE=y
        BR2_SYSTEM_DHCP="eth0"
        BR2_ROOTFS_POST_BUILD_SCRIPT="{}"
        BR2_ROOTFS_POST_SCRIPT_ARGS="{}"
        BR2_LINUX_KERNEL=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE="4.19.262"
        BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG=y
        BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE="{}"
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_DOCKER=y
        BR2_PACKAGE_CA_CERTIFICATES=y
        BR2_PACKAGE_DOCKER_CLI=y
        BR2_PACKAGE_DOCKER_COMPOSE=y
        BR2_PACKAGE_DOCKER_ENGINE=y
        BR2_TARGET_ROOTFS_EXT2=y
        BR2_TARGET_ROOTFS_EXT2_SIZE="512M"
        # BR2_TARGET_ROOTFS_TAR is not set
        """.format(
            infra.filepath("tests/package/copy-sample-script-to-target.sh"),
            " ".join([infra.filepath(i) for i in scripts]),
            infra.filepath("conf/docker-compose-kernel.config"))

    def wait_for_dockerd(self):
        # dockerd takes a while to start up
        _, _ = self.emulator.run('while [ ! -e /var/run/docker.sock ]; do sleep 1; done', 120)

    def docker_test(self):
        # will download container if not available, which may take some time
        self.assertRunOk('docker run --rm -p 8888:8888 busybox:latest /bin/true', 120)

    def docker_compose_test(self):
        # will download container if not available, which may take some time
        self.assertRunOk('docker compose up -d --quiet-pull', 120)
        # container may take some time to start
        self.assertRunOk('while ! docker inspect root-busybox-1 2>&1 >/dev/null; do sleep 1; done', 120)
        self.assertRunOk('wget -q -O /tmp/busybox http://127.0.0.1/busybox', 120)
        self.assertRunOk('cmp /bin/busybox /tmp/busybox', 120)

    def python_docker_test(self):
        self.assertRunOk('python3 ./sample_python_docker.py', 120)

    def do_test(self):
        kernel = os.path.join(self.builddir, "images", "bzImage")
        rootfs = os.path.join(self.builddir, "images", "rootfs.ext2")
        self.emulator.boot(arch="x86_64",
                           kernel=kernel,
                           kernel_cmdline=["root=/dev/vda", "console=ttyS0"],
                           options=["-cpu", "Nehalem",
                                    "-m", "512M",
                                    "-device", "virtio-rng-pci",
                                    "-drive", "file={},format=raw,if=virtio".format(rootfs),
                                    "-net", "nic,model=virtio",
                                    "-net", "user"])
        self.emulator.login()
        self.wait_for_dockerd()
        self.docker_test()
        self.docker_compose_test()
        self.python_docker_test()


class TestDockerComposeRunc(BaseTestDockerCompose):
    def test_run(self):
        self.do_test()


class TestDockerComposeCrun(BaseTestDockerCompose):
    config = BaseTestDockerCompose.config + """
        BR2_PACKAGE_CRUN=y
        """

    def test_run(self):
        self.do_test()
