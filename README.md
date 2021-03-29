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

```
docker run -it --rm  -v /host/path/to/workdir:/home/build/sdk-build ti-sdk-build bash
```

### Start building

TBD