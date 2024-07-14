#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <filename.asm>"
  exit 1
fi

filename="${1%.asm}"
shift

as --32 "$filename.asm" -o "$filename.o"
ld -m elf_i386 "$filename.o" -o "$filename.out"
./"$filename.out" "$@"