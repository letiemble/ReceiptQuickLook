#!/bin/bash

rm -Rf ~/Library/QuickLook/ReceiptQuickLook.qlgenerator
cp -R build/Release/ReceiptQuickLook.qlgenerator ~/Library/QuickLook/
qlmanage -r
#qlmanage -p $1

