#!/bin/sh

UE_PATH=$1
ROS2_WS=$2

cleanup() {
    sudo rm -r -f $1/build $1/install $1/log
    sudo rm -r -f $1/build_renamed $1/install_renamed
}

cleanup $ROS2_WS

export LANG=en_US.UTF-8

# export ROS_DOMAIN_ID=10
# pay attention it can be 'rmw_fastrtps_dynamic_cpp' too
export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
# Building ros by exact UE clang toolchain
export MY_SYS_ROOT_PATH=$UE_PATH"/Engine/Extras/ThirdPartyNotUE/SDKs/HostLinux/Linux_x64/v19_clang-11.0.1-centos7/x86_64-unknown-linux-gnu"
export CC=$MY_SYS_ROOT_PATH"/bin/clang"
export CXX=$MY_SYS_ROOT_PATH"/bin/clang++"

# -latomic issue - see more here https://github.com/ros2/ros2/issues/418
export MY_LINKER_FLAGS="-latomic "\
"-Wl,-rpath=\${ORIGIN} "\
"-Wl,-rpath-link="$MY_SYS_ROOT_PATH" "\
"-Wl,-rpath-link="$MY_SYS_ROOT_PATH"/usr/lib "\
"-Wl,-rpath-link="$MY_SYS_ROOT_PATH"/usr/lib64 "\
"-Wl,-rpath-link=/usr/lib/x86_64-linux-gnu "\
"-Wl,-rpath-link=/usr/lib "

cd $ROS2_WS
colcon build --cmake-clean-cache --cmake-force-configure --continue-on-error --cmake-args "-DCMAKE_SHARED_LINKER_FLAGS='$MY_LINKER_FLAGS'" "-DCMAKE_EXE_LINKER_FLAGS='$MY_LINKER_FLAGS'" -DBUILD_TESTING=OFF --no-warn-unused-cli
