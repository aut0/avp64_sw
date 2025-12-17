# Software for an ARMv8 Virtual Platform (AVP64)

This repository contains software and configuration files for an ARMv8 multi-core virtual platform.
You can find the ARMv8 multi-core virtual platform [here](https://github.com/aut0/avp64).
It was built at the [Institute for Communication Technologies and Embedded Systems](https://www.ice.rwth-aachen.de/) at RWTH Aachen University.

----

## Build

1. To build `avp64_sw`, you need a working installation of [docker](https://docs.docker.com/engine/install/) or [podman](https://podman.io/).

1. Clone git repository:

    ```bash
    git clone --recursive https://github.com/aut0/avp64_sw
    ```

1. The directory used in this project is:

    ```bash
    <source-dir> location of your repo copy,  e.g. /home/lukas/avp64_sw
    ```

1. You can find the build scripts in `<source-dir>/linux`:

    ```bash
    build_linux_buildroot.sh
    build_linux_buildroot_nvdla.sh
    ```

1. Execute the scripts:

    ```bash
    <source-dir>/linux/<script_name>.sh
    ```

   Note: If the user is not a member of the group `docker`, the scripts have to be run as `root`. For more details see docker [documentation](https://docs.docker.com/).

1. The output can be found at `<source-dir>/images`.

1. You can untar the archives into the [avp64/sw](https://github.com/aut0/avp64/tree/master/sw) directory of your [avp64](https://github.com/aut0/avp64) project

----

## License

This project is licensed under the Apache 2.0 license - see the [LICENSE](LICENSE) file for details.
