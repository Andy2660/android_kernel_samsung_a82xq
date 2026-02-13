#!/bin/bash

echo -e "\n[INFO]: BUILD STARTED..!\n"

#init submodules
git submodule init && git submodule update

export KERNEL_ROOT="$(pwd)"
export ARCH=arm64
export KBUILD_BUILD_USER="@ravindu644"

mkdir -p "${KERNEL_ROOT}/out" "${KERNEL_ROOT}/build"

# Export toolchain paths
export PATH="${HOME}/toolchains/clang-r428724/bin:${PATH}"
export LD_LIBRARY_PATH="${HOME}/clang-r428724/lib:${HOME}/clang-r428724/lib64:${LD_LIBRARY_PATH}"

# Set cross-compile environment variables
export BUILD_CROSS_COMPILE="${HOME}/toolchains/aarch64-linux-android-4.9/bin/aarch64-linux-android-"
export BUILD_CC="${HOME}/toolchains/clang-r428724/bin/clang"

# Build options for the kernel
export BUILD_OPTIONS=(
    HOSTLDLIBS="-lyaml"
    -C "${KERNEL_ROOT}"
    O="${KERNEL_ROOT}/out"
    -j"$(nproc)"
    ARCH=arm64
    CROSS_COMPILE="${BUILD_CROSS_COMPILE}"
    CC="${BUILD_CC}"
    CLANG_TRIPLE=aarch64-linux-gnu-
)

build_kernel(){
    # Make default configuration.
    # Replace 'your_defconfig' with the name of your kernel's defconfig
    # clean work directory
    make "${BUILD_OPTIONS[@]}" mrproper
    
    # your defconfig
    make "${BUILD_OPTIONS[@]}" a82xq_kor_skt_defconfig #KernelProtection.config

    # Configure the kernel (GUI)
    make "${BUILD_OPTIONS[@]}" menuconfig

    # Build the kernel
    make "${BUILD_OPTIONS[@]}" Image || exit 1

    # Copy the built kernel to the build directory
    cp "${KERNEL_ROOT}/out/arch/arm64/boot/Image" "${KERNEL_ROOT}/build"

    echo -e "\n[INFO]: BUILD FINISHED..!"
}
build_kernel
