#!/usr/bin/env bash

CI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CI_DIR}/common.sh"

cp build/*/luajit $HOME/.luarocks/bin
# install tesseract trained language data for testing OCR functionality
travis_retry wget http://pkgs.fedoraproject.org/repo/pkgs/tesseract/tesseract-ocr-3.02.eng.tar.gz/3562250fe6f4e76229a329166b8ae853/tesseract-ocr-3.02.eng.tar.gz
tar zxf tesseract-ocr-3.02.eng.tar.gz
cd build/* && export TESSDATA_PREFIX=`pwd`/data && mkdir -p data/tessdata
mv ../../tesseract-ocr/tessdata/* data/tessdata/ && cd ../../
# fetch font for base test
travis_retry wget https://github.com/koreader/koreader/raw/master/resources/fonts/droid/DroidSansMono.ttf
export OUTPUT_DIR=`ls -d ./build/x86_64-*linux-gnu`
mkdir -p ${OUTPUT_DIR}/fonts/droid/
cp DroidSansMono.ttf ${OUTPUT_DIR}/fonts/droid/DroidSansMono.ttf
# finally make test
travis_retry make test
