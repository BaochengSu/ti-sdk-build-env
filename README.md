# Docker image for TI arago Build Environment

This is the docker image for the build environment of [TI's arago project](http://arago-project.org/wiki/index.php/Main_Page)

## Usage

### Using image from docker hub

TBD

### Using image by docker build

```bash
docker build . --tag ti-sdk-build
```

### Navi to sdk code and start docker

```bash
docker run -it --rm  -v /host/path/to/workdir:/home/build/sdk-build ti-sdk-build bash
```

### Start building

```bash
cd sdk-build
./oe-layertool-setup.sh -f configs/processor-sdk-linux/processor-sdk-linux-<version>.txt
cd build
echo "INHERIT += \"own-mirrors\"" >> conf/local.conf
echo "SOURCE_MIRROR_URL = \"https://software-dl.ti.com/processor-sdk-mirror/sources/\"" >> conf/local.conf
echo "ARAGO_BRAND  = \"psdkla\"" >> conf/local.conf
echo "DISTRO_FEATURES_append = \" virtualization\"" >> conf/local.conf
echo "IMAGE_INSTALL_append = \" docker\"">> conf/local.conf
. conf/setenv
TOOLCHAIN_BASE=$HOME MACHINE=am65xx-evm bitbake -k tisdk-default-image
```
