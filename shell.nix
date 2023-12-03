{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    cmake
    python3
    ninja
  ];

  buildInputs = with pkgs; [
    zlib
  ];
}

# mkdir build
# cd build
# cmake ../llvm -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLLVM_ENABLE_PROJECTS="clang;lld" -DLLVM_TARGETS_TO_BUILD="Mips;X86" -DLLVM_DEFAULT_TARGET_TRIPLE=mipsel-windows-gnu -GNinja
# for t in clang llc llvm-lib lld llvm-rc llvm-ranlib llvm-objdump llvm-dlltool; do ninja -j3 $t; done
