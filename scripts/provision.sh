#!/bin/bash

# Very very important!
sudo apt-get update

# Install all the tools required to build the Swift source
sudo apt-get install -y git cmake ninja-build clang python uuid-dev libicu-dev icu-devtools libbsd-dev libedit-dev libxml2-dev libsqlite3-dev swig libpython-dev libncurses5-dev pkg-config

# For Ubuntu 14.04... remove below 3 lines for 15.10+
sudo apt-get install -y clang-3.6
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.6 100
sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.6 100

cd ~

# Create a build script if it does not exist
if [ ! -f /home/vagrant/build-from-source.sh ]; then
cat > build-from-source.sh << EOF
#!bin/bash
mkdir -p ~/swift-src
cd ~/swift-src
git clone https://github.com/apple/swift.git
cd swift

# If you want to build Swift 2.2, uncomment the line below.
# git checkout swift-2.2-branch

# Clone required repos
./utils/update-checkout --clone
# Build and be patient
./utils/build-script --preset=buildbot_linux_1404 install_destdir=~/swift-build installable_package=~/swift.tar.gz

# Sync Swift build to /usr/ (change to /usr/local/ or /opt/vendor/ if you prefer)
sudo rsync -rl ~/swift-build/usr/ /usr/
EOF
fi

# Run the build script
if ! type "swift" >/dev/null 2>&1; then
	sudo bash build-from-source.sh
fi


# Delete /etc/udev/rules.d/70-persistent-net.rule if it exists
[ -f /etc/udev/rules.d/70-persistent-net.rule ] && sudo rm -f /etc/udev/rules.d/70-persistent-net.rule || true

# Zero the filesystem to help compression
sync
sudo dd if=/dev/zero of=/EMPTY bs=1M || true
sudo rm -f /EMPTY
sync
echo 3 > /proc/sys/vm/drop_caches
sync
