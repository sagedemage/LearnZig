# Install Zig from Source on Ubuntu 22.04

## Install Zig 0.10.1 from Source

### Dependencies
* cmake >= 2.8.12
* gcc >= 7.0.0 or clang >= 6.0.0
* LLVM Project == 15.X
  * LLVM == 15.X
  * Clang == 15.X
  * LLD == 15.X

## Get Zig Source Code from Release: 
* [zig repository](https://github.com/ziglang/zig)

## Install LLVM Project Dependencies
```
sudo apt install llvm-15-dev liblld-15-dev libclang-15-dev libclang-common-15-dev 
```

### Build Zig
```
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
sudo make install
```

### Install Zig
```
cd build
sudo cp stage3/bin/zig /usr/local/bin/
sudo cp stage3/lib/zig /usr/local/lib/
```

## Resources
* https://github.com/ziglang/zig/wiki/Building-Zig-From-Source


