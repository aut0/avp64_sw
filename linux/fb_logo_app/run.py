#!/usr/bin/env python3

import pexpect
import sys
import os

from PIL import Image, ImageChops
from deps.pyvp.vcml.session import Session

file_dir = os.path.dirname(os.path.abspath(__file__))

def compare_images(image1_path, image2_path):
    img1 = Image.open(image1_path)
    img2 = Image.open(image2_path)

    # Ensure images have the same mode and size
    if img1.mode != img2.mode or img1.size != img2.size:
        return False

    diff = ImageChops.difference(img1, img2)

    return diff.getbbox() is None

def take_screenshot(session: Session, path: str = "fb.bmp"):
    fb = session.find_module("system.fb1")
    screenshot = fb.find_command("screenshot")

    session.stop()
    screenshot.execute((path,))


def main():
    avp64_home = os.getenv("AVP64_HOME")
    if avp64_home is None:
        print("Please set the AVP64_HOME environment variable.")
        sys.exit(1)
    if not os.path.exists(avp64_home):
        print(f"AVP64_HOME directory {avp64_home} does not exist.")
        sys.exit(1)

    config = {
        "executable": os.path.join(avp64_home, "bin", "avp64-runner"),
        "cfg": os.path.join(avp64_home, "sw", "buildroot_6_5_6-x1.cfg"),
        "session-port": 8888,
        "libpath": os.path.join(avp64_home, "lib")
    }

    if not os.path.exists(config["executable"]):
        print(f"Executable {config['executable']} does not exist.")
        sys.exit(1)
    if not os.path.exists(config["cfg"]):
        print(f"Configuration file {config['cfg']} does not exist.")
        sys.exit(1)
    if not os.path.exists(config["libpath"]):
        print(f"Library path {config['libpath']} does not exist.")
        sys.exit(1)

    properties = {
        "system.session": config["session-port"],
        "system.fb0.displays": "",
        "system.fb1.displays": "",
        "system.virtio_input.displays": "",
        "system.term0.backends": "term",
        "system.canbridge.backends": ""
    }
    properties_string = " ".join([f"-c {key}={properties[key]}" for key in properties])

    cmd = f"{config['executable']} -f {config['cfg']} {properties_string}"
    process = pexpect.spawn(cmd, logfile=sys.stdout, timeout=None, encoding="utf-8", env=os.environ | {"LD_LIBRARY_PATH": config["libpath"]})
    process.stdout = sys.stdout

    # connect to vp and start simulation
    process.expect(f"vspserver waiting on port {config['session-port']}")
    session = Session(f"localhost:{config['session-port']}")
    session.run()

    # login
    process.expect("avp64 login:")
    process.sendline("root")
    process.expect("# ")

    # start application
    process.sendline("/root/png_to_fb/png_to_fb /root/png_to_fb/mwr_logo.png /dev/fb1")
    process.expect("# ")

    path = os.path.abspath(os.path.join(file_dir, "system.fb1.bmp"))
    take_screenshot(session, path)
    test_pass = compare_images(path, os.path.join(file_dir, "assets", "system.fb1_ref.bmp"))

    session.kill()
    process.expect(pexpect.EOF)

    if test_pass:
        print("test passed")
    else:
        print("test failed")
    print(f"Screenshot: {path}")


if __name__ == "__main__":
    main()
