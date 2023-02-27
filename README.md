# CannibalOS
*Copyright (c) 2023 - Laura Raine*

<br />

*CannibalOS as of 26/02/2023*

![](docs/image.png)

## Prerequisites
* Docker Desktop
* Python 3.5+
* Git
* QEMU
* A Brain and Common Sense :p
* Windows with PowerShell (for linux look below)

## Attention Linux People
* Instead of chroot_docker.py, run `docker run --rm -it -v "$(pwd)":/root/env cannibalos-env`
* instead of vm_test32.py, run `qemu-system-x86_64 -cdrom publish/amd64/iso/cannibal-amd64.iso`
* instead of vm_test64.py, run `qemu-system-i386 -cdrom publish/ia32/iso/cannibal-ia32.iso`

## Build Instructions
1. run `py tools\prep_env.py`
2. run `py tools\prep_docker.py`
3. run `py tools\chroot_docker.py`
4. run `make build-amd64` **inside of the container !**
5. run `py tools\vm_test.py` **in a new terminal !**

## Credits
* [CodePulse](https://www.youtube.com/@CodePulse) for his amazing tutorial on writing a 64-bit kernel
* [Daedalus](https://www.youtube.com/@DaedalusCommunity) for his series on building an OS, helping me understand the basics a bit
* [OSDev Wiki](http://wiki.osdev.org) for the extensive documentation surrounding OS Development
* [OSDev Discord](https://discord.gg/osdev) for their support when my braincells went to get milk :p
* [EinTim](http://eintim.one) for giving me the idea and also helping me with some 1iq issues
