Auto-generated [C3](https://c3-lang.org/) bindings for the [sokol headers](https://github.com/floooh/sokol).

To include sokol in your project you can copy the [sokol](sokol/) directory.

**This project is Work in Progress and interfaces may change!!**

# Build

Currently only macOS is supported. Other platforms are work in progress.

## macOS

1. First build the required static libraries:
    ```sh
    cd sokol
    ./build_clibs_macos.sh
    cd ..
    ```

2. Then build example 
    ```sh
    mkdir build
    cd build

    c3c compile \
        -z -framework -z Foundation \
        -z -framework -z CoreGraphics \
        -z -framework -z Cocoa \
        -z -framework -z QuartzCore \
        -z -framework -z CoreAudio \
        -z -framework -z AudioToolbox \
        -z -framework -z Metal \
        -z -framework -z MetalKit \
        -l ../sokol/sokol_macos_arm64_metal_debug.a \
        ../sokol/*.c3 \
        ../examples/clear/main.c3 \
        -o clear
    ```
