# Framebuffer Logo App

This directory contains the source code of the `png_to_fb` application, which writes a png file to a framebuffer.

## png_to_fb Application

The `png_to_fb` application is built from the [png_to_fb.cpp](./src/png_to_fb.cpp) file.
Durnig the creation of the Buildroot Linux image (execution of [build_linux_buildroot.sh](../build_linux_buildroot.sh) script), the application is complied and placed into the rootfs image.
The application is placed in `/root/png_to_fb/png_to_fb` in the rootfs image.

After the boot of avp64, the application can be executed like this:

```bash
/root/png_to_fb/png_to_fb /root/png_to_fb/mwr_logo.png /dev/fb1
```

The application expects two parameters, the first one is a png image, the second one a framebuffer device.
The png image is written to the framebuffer.
The [mwr_logo.png](./assets/mwr_logo.png) is copied to the rootfs to /root/png_to_fb/mwr_logo.png.

After the execution, the `fb1` should look like this:

![screenshot](./assets/system.fb1_ref.bmp)

## Automatic Testing

The [run.py](./run.py) script can be used to launch avp64, execute the `png_to_fb` application, create a screenshot of the framebuffer and compare the screenshot against a golden model.

1. Build and install avp64 (see [avp64 Readme](https://github.com/aut0/avp64/blob/master/README.md)).
1. Store the used install directory in the `AVP64_HOME` variable

    ```bash
    export AVP64_HOME=<avp64-install-dir>
    ```

    The following paths should exist:

    ```bash
    ${AVP64_HOME}/bin/avp64-runner # the avp64 executable
    ${AVP64_HOME}/sw/buildroot_6_5_6-x1.cfg # the avp64 config file to execute the buildroot linux image created by this repository
    ${AVP64_HOME}/lib/libocx-qemu-arm.so # the ocx-qemu-arm shared library
    ```

1. Setup a Python virtual environment

    ```bash
    cd <avp64-sw-root>/linux/fb_logo_app
    python3 -m venv .venv # create venv
    source .venv/bin/activate # activate the venv
    pip3 install -r requirements.txt
    ```

1. Run the [run.py](./run.py) script

    ```bash
    ./run.py
    ```

You should see the boot output of avp64.
The Python script uses [MachineWare's pyvp](https://github.com/machineware-gmbh/pyvp) to connect to avp64.
The [pexpect](https://pexpect.readthedocs.io/en/stable/#) Python package is used to start the avp64 process, handle the Linux login and run the `png_to_fb` application.
Then, pyvp requests a screenshot of the framebuffer.
This screenshot is comapared against the golden model ([assets/system.fb1_ref.bmp](./assets/system.fb1_ref.bmp)).

After a successful run, you should see this result:

```text
test passed
Screenshot: <avp64-sw-root>/linux/fb_logo_app/system.fb1.bmp
```
