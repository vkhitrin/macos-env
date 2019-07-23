# DZ60

![ISO Layout with direction keys](https://i.imgur.com/FEIJrJZ.png)

## Compiling firmware

This repo contains a compiled QMK firmware for dz60.

Steps to create a new firmware with new configuration:

**Method 1 (Easy):**
1) Navigate to [QMK Configurator](https://config.qmk.fm)
2) Upload [dz60_layout_60_b_iso_mine.json](dz60_layout_60_b_iso_mine.json)
3) Edit key configuration
4) Compile & Download firmware
5) Flash firmware using QMK toolbox

**Method 2 (Advanced):**
1) Navigate to [QMK Configurator](https://config.qmk.fm)
2) Upload [dz60_layout_60_b_iso_mine.json](dz60_layout_60_b_iso_mine.json)
3) Edit key configuration
4) Download keymap only
5) Clone [QMK Firmware repo](https://github.com/qmk/qmk_firmware/)
6) Create a custom keymap directory for [dz60](https://github.com/qmk/qmk_firmware/tree/master/keyboards/dz60/keymaps)
7) Copy files from step 5 to created directory in step 6
8) Edit dz60 configuration if needed
9) Compile firmware using: `make dz60:<keymap_name>` from root directory, firmware will be compiled to `.build` directory
10) Flash firmware using QMK toolbox