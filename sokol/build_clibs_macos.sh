set -e

backend_define=SOKOL_METAL
backend=metal

for arch in arm64 x86_64; do
    # Release
    MACOSX_DEPLOYMENT_TARGET=10.13 cc -c -O2 -x objective-c -arch $arch -DNDEBUG -DIMPL -D$backend_define c/sokol.c
    ar rcs sokol_macos_${arch}_${backend}_release.a sokol.o
    rm sokol.o

    # Debug
    MACOSX_DEPLOYMENT_TARGET=10.13 cc -c -g -x objective-c -arch $arch -DIMPL -D$backend_define c/sokol.c
    ar rcs sokol_macos_${arch}_${backend}_debug.a sokol.o
    rm sokol.o
done
