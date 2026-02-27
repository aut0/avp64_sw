# Software for an ARMv8 Virtual Platform (AVP64)

This repository contains software and configuration files for the [ARMv8 multi-core virtual platform (AVP64)](https://github.com/aut0/avp64).
It was built at the [Institute for Communication Technologies and Embedded Systems](https://www.ice.rwth-aachen.de/) at RWTH Aachen University.

----

## Overview

The following images can be built:

* [benchmark](./benchmark/): Baremetal benchmarks
  * **CoreMark:** CoreMark is a CPU benchmark developed by EEMBC that measures core processor performance using common embedded system workloads such as list processing, matrix manipulation, and state machines.

  * **Dhrystone:** Dhrystone is a synthetic benchmark created by Reinhold P. Weicker to evaluate integer performance and general-purpose CPU efficiency using typical systems programming constructs.

  * **STREAM:** STREAM is a memory bandwidth benchmark developed by John D. McCalpin that measures sustainable memory throughput and the corresponding computation rate for simple vector kernels.

  * **Whetstone:** Whetstone is one of the earliest synthetic benchmarks, developed at National Physical Laboratory, designed to measure floating-point arithmetic performance in scientific computing workloads.

* [linux](./linux/): Buildroot-based Linux image
* [xen](./xen/): Xen is an open-source type-1 (bare-metal) hypervisor originally developed at the University of Cambridge that enables multiple operating systems to run securely and efficiently on the same physical hardware through virtualization.
* [zephyr](./zephyr/): Zephyr-RTOS-based applications

----

## Prerequisites

1. To build `avp64_sw`, you need a working installation of [docker](https://docs.docker.com/engine/install/) or [podman](https://podman.io/).

1. Clone the git repository:

    ```bash
    git clone --recursive https://github.com/aut0/avp64_sw
    ```

1. The directory used in this project is:

    ```text
    <source-dir> location of your repo copy, e.g. /home/lukas/avp64_sw
    ```

----

## License

This project is licensed under the Apache 2.0 license - see the [LICENSE](LICENSE) file for details.
