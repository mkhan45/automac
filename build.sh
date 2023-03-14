#!/bin/sh
# https://mjones.network/how-to-write-neovim-plugins-in-rust

mkdir -p ./lua/automac

cargo build --release
rm -f ./lua/automac.so
cp ./target/release/libautomac.so ./lua/automac_lib.so

mkdir -p ./lua/deps
cp ./target/release/deps/*.rlib ./lua/deps
