#!/usr/bin/bash
export QEMU_LD_PREFIX=/usr/riscv64-linux-gnu/
/usr/bin/qemu-riscv64-static -g 1234 .pio/build/linux_riscv/firmware.elf < numbers.txt


