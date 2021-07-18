#!/bin/sh

ARCH=aarch64
CHAN=beta
LIBUNWIND=/usr/lib/libunwind.so.1

mkdir -p build

#curl "https://static.rust-lang.org/dist/rust-$CHAN-$ARCH-unknown-linux-musl.tar.gz" -o build/rust.tar -c -
#tar -xf build/rust.tar -C build

make -C libgcc

mkdir -p build/rust-root
./build/rust-$CHAN-$ARCH-unknown-linux-musl/install.sh \
--disable-ldconfig \
--destdir=$(pwd)/build/rust-root \
--prefix=/

# Can't just symlink here 'cause rustc needs __clear_cache which isn't exposed
# by libunwind
echo 'Copying libgcc_s shim'
cp $(pwd)/libgcc/libgcc_s.so $(pwd)/build/rust-root/lib/libgcc_s.so.1

# Symlink libunwind for dynamic builds to link to
echo 'Symlinking libunwind'
ln -sr $LIBUNWIND $(pwd)/build/rust-root/lib/rustlib/aarch64-unknown-linux-musl/lib/libgcc_s.so

export RUSTC=$(pwd)/build/rust-root/bin/rustc

echo "Checking Sanity"

$RUSTC sanity.rs -C target-feature=-crt-static -o build/sanity
./build/sanity
