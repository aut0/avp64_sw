# Software for an ARMv8 Virtual Platform (AVP64)
This repository contains software for an ARMv8 multi-core virtual platform.
You can find the ARMv8 multi-core virtual platform [here](https://github.com/aut0/avp64).
It was build at the Institute for Communication Techonlogies and Embedded Systems at RTWH Aachen University.

----
## Build 

1. In order to build `avp64_sw`, you need a working installation of [docker](https://docs.docker.com/engine/install/).

2. Clone git repository:
    ```
    git clone --recurse-submodules https://github.com/aut0/avp64_sw
    ```

3. The directory used in this project is:
    ```
    <source-dir> location of your repo copy,  e.g. /home/lukas/avp64_sw
    ```

4. You can find the build scripts in `<source-dir>/linux`:
    ```
    build_linux_bootcode_el1el2.sh
    build_linux_bootcode_el3.sh
    build_linux_buildroot.sh
    build_linux_nvdla_buildroot.sh
    ```

5. Execute the scripts:
    ```
    <source-dir>/linux/<script_name>.sh
    ```  
   Note: If the user is not a member of the group `docker`, the scripts have to be run as `root`. For more details see docker [documentation](https://docs.docker.com/). 

6. The output can be found at `<source-dir>/linux/BUILD`.

----
## License
This project is licensed under the Apache 2.0 license - see the
[LICENSE](LICENSE) file for details.
