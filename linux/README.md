# Buildroot-based Linux Image

This directory contains configuration files and scripts to build a Buildroot-based Linux image for AVP64.
Buildroot is a tool that automates the process of building Linux for embedded system platforms.

## Build

1. You can find the following build scripts:

    * [build_linux_buildroot.sh](./build_linux_buildroot.sh): Builds the image for the default AVP64
    * [build_linux_buildroot_nvdla.sh](./build_linux_buildroot_nvdla.sh): Includes the driver and software for the NVIDIA Deep-Learning Accelerator (NVDLA)

    Buildroot is responsible for fetching Linux source code, configuring, and building it.
    Furthermore, it adds utilities and tools to the image.

1. To configure the buildroot image, the `menuconfig_buildroot` script can be executed:

    ```bash
    ./menuconfig_buildroot
    ```

    This allows, e.g., to select the target architecture, build options (e.g., optimizations), and included packages.
    The configuration is stored in the [files/avp64-linux-defconfig](./files/avp64-linux-defconfig) file.
    Do not manually change this file.
    *After you changed the buildroot config, re-execute `build_linux_buildroot.sh` for the changes to be applied.*

1. To modify the Linux kernel config, run:

    ```bash
    ./menuconfig_linux
    ```

    This will allow you to configure the Linux kernel.
    You can, e.g., select the drivers that are included, enable POSIX Message Queues, add profiling support, change the page size, endianness, and much more.
    The configuration is stored in the [files/avp64_linux_kernel.config](./files/avp64_linux_kernel.config) file.
    Do not manually change this file.
    *After you changed the kernel config, re-execute `build_linux_buildroot.sh` for the changes to be applied.*

1. Execute the build script:

    ```bash
    <source-dir>/linux/build_linux_buildroot.sh
    ```

   Note: If you are using docker and you are not a member of the group `docker`, the scripts have to be run as `root`.
   For more details see docker [documentation](https://docs.docker.com/).

1. The output files can be found at `BUILD/buildroot/output/images`.
    This folder will contain (at least):

    * Different Device Tree Blobs (.dtb files) with a binary representation of the hardware description.
      You can convert them into a human-readable text format using the device-tree compiler `dtc`.
      On Ubuntu, `dtc` can be installt using:

      ```bash
      sudo apt-get install device-tree-compiler
      ```

      To convert a binary device-tree blob (.dtb file) into a device-tree source file (.dts file), run:

      ```bash
      dtc -I dtb -O dts -o <name you choose>.dts <path to the .dtb>
      ```

      Differnt device trees are compiled for differnt numbers of simulated cores (`avp64x1.dtb` for the single-core VP, `avp64x4` for the quad-core VP, ...).

    * boot.elf:
      An ELF-format version of the bootloader

    * buildroot.elf:
      An ELF-format version of the Linux kernel executable.

    * buildroot.bin:
      The binary version of the buildroot.elf image.
      It contains a raw image that can directly be put into the RAM of the VP.
      In contrast to the ELF version, it does not contain the ELF header, debugging symbols, and other information.

    * buildroot_6_5_6.cfg:
      The VP configuration file

    * sdcard.img:
      It contains one partitions that holds the root filesystem (with /bin, /etc, and /usr, ...).

1. You can find a tarball that contains all needed build artifcats in the `<source-dir>/images` directory.
    This tarball contains the VP configuration files and the needed software images.

1. You can untar this tarball into the [avp64/sw](https://github.com/aut0/avp64/tree/master/sw) directory of your [avp64](https://github.com/aut0/avp64) project

**Login information:**

**user:** root  
**password:** root

----

## Adding a user-space application to the Linux image

Read this paragraph if you want to add an application to the Linux image.

To add files to the filesystem of the SD-card image, the overlay directories `files/overlay_<configuration>` can be used.
If you are building a Linux image for the default AVP64 platform, use the `files/overlay_default` directory.
All files you copy there will be added to the filesystem.
If you place a file in, e.g., `files/overlay_default/etc`, it will be placed to `/etc` in the created filesystem.
Since the default user is `root`, you can place normal userspace applications in `/root/`.
Ensure that the *executable* flag is set (`chmod +x <application path>`).

To cross-compile applications, you can use the toolchain that is supplied by buildroot.
You find a tarball in the `<source-dir>/images` folder (e.g., `aarch64-buildroot-linux-gnu_sdk-buildroot.tar.gz`).

Don't forget to rebuild your image after you modified the overaly.
Hint: When you rebuild your image, buildroot copies all files from the overlay directory to the image.
If you delete a file from the overlay directory and rebuild the image, the deleted files will **not** be removed from the image.
The easiest solution in this case is to delete the `BUILD` folder and rebuild a clean image.

**DO NOT** modify the generated files (inside `BUILD`)

### Launch the application from a terminal

1. Wait until the boot finished and login as root (pw: root)
1. Navigate to the location of the application once you get a shell (`#`).
    If you placed the application in `/root`, you are already there.
1. Run the application

### Create a service to automatically run an application

If you'd like your application to automatically run after the boot finished without the user intervention, you can create an init script.
Init scripts are placed in `/etc/init.d` in the filesystem of the image and are automatically launched by `/sbin/init`.
The init process uses the `/et/inittab` configuration file, which runs the `/etc/init.d/rcS` script.
This script executes all scripts in the `/etc/init.d/` directory whose name starts with `S`.
The scripts are typically named `S[0-99]<purpose>`, e.g., `S40network` to enable the network device.
The number is used to define the order in which the scripts are executed.

After you built the Linux image once, you can find examples of init scripts in the `BUILD/buildroot/output/linux/target/etc/init.d` directory.

To create a new service:

1. Add a script named `S[0-99]<service-name>` under `files/overlay_default/etc/init.d/`.
    Ensure the script is executable (`chmod +x <scriptname>`).

1. Rebuild the Linux image

----

## Boot Process

Most systems include non-volatile (flash) memory that stores the bootloader (BIOS/UEFI on some platforms).
This software is executed immediately after the system is powered on.

The bootloader is responsible for loading the operating system (e.g., the Linux kernel) from persistent storage (such as an SD card, HDD, SSD, etc.) into system RAM.
It typically also loads or generates the compiled device tree and places it in RAM.
Finally, it transfers control to the operating system by jumping to the kernel’s entry point.

For the Linux kernel on ARMv8 systems, the kernel expects the address of the compiled device tree to be passed in register `x0` at entry.

In this Linux kernel image, we skip simulating a full bootloader.
Instead, we place the Linux image and the compiled device tree directly into RAM by defining the corresponding property in the VP configuration:

```ini
system.ram.images = ${dir}/boot.bin@0x00000000 \
                    ${dir}/buildroot.bin@0x00200000 \
                    ${dir}/avp64x${system.cpu.ncores}.dtb@0x07f00000
```

The boot code, which is loaded at the beginning of RAM, is the compiled version of linux_bootcode.
Its main responsibilities are:

* Lowering the exception level from EL3 to EL2
* Placing the address of the compiled device tree into register x0
* Jumping to the Linux kernel entry point

### Multi-core boot

When using a multi-core version of AVP64, the [linux_bootcode](./linux_bootcode/el3/) ensures that only core 0 performs the primary boot sequence.

Based on the core ID, core 0 jumps to the Linux kernel entry point, while the other cores enter a spin loop.
These secondary cores continuously poll a shared memory location.
When Linux decides to bring up additional cores during the boot process, core 0 writes to this memory location to release them.

Once released, the secondary cores exit the spin loop and jump to the Linux kernel entry point.

----

## Debugging

If you want to debug the kernel drivers, make sure you have debug symbols.
You can enable them from the menuconfig.

You can run Linux and attach using `gdb-multiarch` in Ubuntu.
If you're running it on a simulator, make sure you specify the gdb port in the .cfg with:

```bash
system.cpu.gdb_port   = <your gdb port>
```

The default GDB port is set to `5555`.
