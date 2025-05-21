#!/bin/sh

rm -f ./build/target/*
mkdir -p ./build/target/

# Building `user-guide` documents
./build/md_to_pdf ./docs/user-guide/ru/ --assets ../../assets --output ./build/target/user-guide-ru --template ./docs/user-guide/template.html

# Building `life-cycle-processes` documents
./build/md_to_pdf ./docs/life-cycle-processes/ru/ --assets ../../assets --output ./build/target/life-cycle-processes-ru --template ./docs/life-cycle-processes/template.html

# Building `architecture` documents
./build/md_to_pdf ./docs/architecture/ru/ --assets ../../assets --output ./build/target/architecture-ru --template ./docs/architecture/template.html

# Building `source-and-compiling` documents
./build/md_to_pdf ./docs/source-and-compiling/ru/ --assets ../../assets --output ./build/target/source-and-compiling-ru --template ./docs/source-and-compiling/template.html
