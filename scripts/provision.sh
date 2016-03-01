#!/bin/bash
#
# Setup the the box. This runs as root

apt-get -y update

apt-get -y install curl

# You can install anything you need here.
apt-get install -y git cmake ninja-build clang uuid-dev libicu-dev icu-devtools libbsd-dev libedit-dev libxml2-dev libsqlite3-dev swig libpython-dev libncurses5-dev pkg-config

apt-get install -y clang-3.6
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.6 100
sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.6 100

cd ~
mkdir swift-src
cd swift-src

git clone https://github.com/apple/swift.git swift
git clone https://github.com/apple/swift-llvm.git llvm
git clone https://github.com/apple/swift-clang.git clang
git clone https://github.com/apple/swift-lldb.git lldb
git clone https://github.com/apple/swift-cmark.git cmark
git clone https://github.com/apple/swift-llbuild.git llbuild
git clone https://github.com/apple/swift-package-manager.git swiftpm
git clone https://github.com/apple/swift-corelibs-xctest.git
git clone https://github.com/apple/swift-corelibs-foundation.git
git clone https://github.com/ninja-build/ninja.git

cd swift
utils/build-script --preset=buildbot_linux_1404 install_destdir=/tmp/install installable_package=/tmp/swift.tar.gz
sudo rsync -a /tmp/install/ /opt/apple/swift-2.2/
