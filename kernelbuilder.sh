#!/bin/bash
# This script installs dependencies, sets up the environment, and builds Linux kernel

# Define variables for the kernel version and download URL
KERNEL_VERSION="6.9.3"
KERNEL_URL="https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${KERNEL_VERSION}.tar.xz"
KERNEL_ARCHIVE="linux-${KERNEL_VERSION}.tar.xz"
KERNEL_DIR="/home/Kernels/linux-${KERNEL_VERSION}"
DOWNLOAD_DIR="/home/Kernels/downloads"

# Function to install necessary dependencies
install_dependencies() {
    sudo apt update
    sudo apt install -y build-essential libncurses-dev bison flex libssl-dev libelf-dev \
    libncurses5-dev libncursesw5-dev bc rsync
}

# Function to set up the build environment
setup_build_environment() {
    mkdir -p ${KERNEL_DIR}
    mkdir -p ${DOWNLOAD_DIR}
}

# Function to download the Linux kernel source code
download_kernel() {
    cd ${DOWNLOAD_DIR}
    wget ${KERNEL_URL}
}

# Function to extract the kernel tarball
extract_kernel() {
    tar -xf ${KERNEL_ARCHIVE} -C ${KERNEL_DIR} --strip-components=1
}

# Function to build the kernel
build_kernel() {
    cd ${KERNEL_DIR}
    cp /boot/config-$(uname -r) .config
    yes '' | make oldconfig
    make -j$(nproc)
}

# Function to install the kernel modules and the kernel
install_kernel() {
    cd ${KERNEL_DIR}
    sudo make modules_install
    sudo make install
    sudo update-grub
}

# Function to clean up the build environment
cleanup() {
    rm -f ${DOWNLOAD_DIR}/${KERNEL_ARCHIVE}
}

# Main script execution
main() {
    install_dependencies
    setup_build_environment
    download_kernel
    extract_kernel
    build_kernel
    install_kernel
    cleanup
    echo "Kernel ${KERNEL_VERSION} installation complete. Please reboot your system to use the new kernel."
}

# Execute the main function
main

