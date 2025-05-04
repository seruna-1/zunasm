#! /bin/sh

fasm zuna.asm

ar rcs libzunasm.a zuna.o

rm zuna.o

clang zuna.c libzunasm.a

rm libzunasm.a
